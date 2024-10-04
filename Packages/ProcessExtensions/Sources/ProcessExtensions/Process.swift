public import Foundation
import os.log

extension Process {

  public static func run(
    with interpreter: String, inProfile shellProfile: String, command: String,
    currentDirectoryURL: URL? = nil
  ) async throws -> ShellOutput {
    // Adjust to your specific zsh profile file if necessary

    let tempName = UUID().uuidString
    let tempScriptURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(
      tempName)

    // Create a temporary script to source the profile and run the nvm command
    let script = """
      #!\(interpreter)
      source \(shellProfile)
      \(command)
      """

    try script.write(to: tempScriptURL, atomically: true, encoding: .utf8)
    try FileManager.default.setAttributes(
      [.posixPermissions: 0o755], ofItemAtPath: tempScriptURL.path)
    let result = try await Process.runShellCommand(
      tempScriptURL.path, currentDirectoryURL: currentDirectoryURL)

    do {
      // Clean up the temporary script
      try FileManager.default.removeItem(at: tempScriptURL)
    } catch {
      Logger(subsystem: "swoop", category: "execute").warning("Unable to delete temporary file.")
    }

    return result
  }

  public static func execute(
    _ executable: String,
    arguments: [String] = [],
    currentDirectoryURL: URL? = nil,
    _ accceptableStatus: @Sendable @escaping (Int) -> Bool = { $0 == 0 }
  ) async throws -> ShellOutput {
    try await self.execute(
      .init(filePath: executable),
      arguments: arguments,
      currentDirectoryURL: currentDirectoryURL,
      accceptableStatus
    )
  }

  // Function to run a shell command and capture its output
  public static func execute(
    _ executableURL: URL,
    arguments: [String] = [],
    currentDirectoryURL: URL? = nil,
    _ accceptableStatus: @Sendable @escaping (Int) -> Bool = { $0 == 0 }
  ) async throws -> ShellOutput {
    let process = Process()
    process.executableURL = executableURL
    process.arguments = arguments
    process.currentDirectoryURL = currentDirectoryURL

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    return try await withCheckedThrowingContinuation { continuation in
      do {
        try process.run()
      } catch {
        continuation.resume(throwing: error)
      }

      process.waitUntilExit()

      let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
      let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

      let outputString = String(decoding: outputData, as: UTF8.self)
      let errorString = String(decoding: errorData, as: UTF8.self)

      let output = ShellOutput(output: outputString, error: errorString)

      if let error = TerminationError(
        status: Int(process.terminationStatus),
        reason: process.terminationReason.rawValue,
        output: output,
        accceptableStatus: accceptableStatus
      ) {
        continuation.resume(throwing: error)
      } else {
        continuation.resume(returning: output)
      }
    }
  }

  @discardableResult
  public static func runShellCommand(
    executableBasePath: String = "/usr/bin/env", _ command: String, arguments: [String] = [],
    currentDirectoryURL: URL? = nil,
    accceptableStatus: @Sendable @escaping (Int) -> Bool = { $0 == 0 }
  ) async throws -> ShellOutput {
    return try await execute(
      executableBasePath,
      arguments: [command] + arguments,
      currentDirectoryURL: currentDirectoryURL,
      accceptableStatus
    )
  }
}
