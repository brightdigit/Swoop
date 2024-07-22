
import Foundation
import ArgumentParser

import Foundation

enum CommandError : Error {
  case missingInstallation
}


struct ShellOutput {
  let output: String
  let error : String
}

protocol Command : Sendable {
  func run () async throws
}

protocol DependenciesCommand : Command {
  var dependencies : [any Command] { get }
  func execute() async throws
}

extension DependenciesCommand {
  func run() async throws {
    try await withThrowingTaskGroup(of: Void.self) { group in
      for dependency in self.dependencies {
        group.addTask {
          try await dependency.run()
        }
      }
      try await group.waitForAll()
    }
    try await self.execute()
  }
}

enum NodeVersionManager : ShellCommand {
  static let commandName = "nvm"
  
  struct Verify : VerifyInstallation {
    typealias ShellCommandType = NodeVersionManager
  }
}

protocol ShellCommand {
  static var commandName : String { get }
}

protocol VerifyInstallation : Command {
  associatedtype ShellCommandType : ShellCommand
}

func checkNVMInstalled() async -> Bool {
  
    let shellProfile = "~/.zshrc" // Adjust to your specific shell profile file if necessary
    
    // Create a temporary script to source the profile and check for nvm
    let script = """
    #!/bin/zsh
    source \(shellProfile)
    command -v nvm
    """
    
    // Write the script to a temporary file
    let tempScriptURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("check_nvm.sh")
    do {
        try script.write(to: tempScriptURL, atomically: true, encoding: .utf8)
        // Make the script executable
      try await Process.runShellCommand("chmod", arguments: ["+x", tempScriptURL.path])
    } catch {
        print("Failed to write or set permissions for the temporary script: \(error)")
        return false
    }
    
    // Run the temporary script
  let result : ShellOutput
  do {
    result = try await Process.runShellCommand(executableBasePath: "/bin/zsh", tempScriptURL.path)
  } catch {
    dump(error)
    return false
  }
    // Clean up the temporary script
    try? FileManager.default.removeItem(at: tempScriptURL)
    
  if !result.output.isEmpty {
        print("nvm is installed. Command path:\n\(result.output)")
        return true
  } else if !result.error.isEmpty {
        print("Error checking nvm installation:\n\(result.error)")
    } else {
        print("nvm is not installed.")
    }
    
    return false
}

extension VerifyInstallation {
  func run() async throws {
    do {
      try await Process.runShellCommand("type", arguments: [Self.ShellCommandType.commandName])
    } catch let error as TerminationError where error.status == 1 {
      dump(error)
      assert(error.output.error == "\(Self.ShellCommandType.commandName) not found")
      throw CommandError.missingInstallation
    }
  }
}

struct TerminationError : Error {
  private init(status: Int, reason: Int, output: ShellOutput) {
    self.status = status
    self.reason = reason
    self.output = output
  }
  
  let status : Int
  let reason : Int
  let output: ShellOutput
  
  init?(status: Int, reason: Int, output: ShellOutput, accceptableStatus: @Sendable @escaping (Int) -> Bool) {
    let statusFailed = accceptableStatus(status)
    
    guard !statusFailed || reason != 1 else {
      return nil
    }
    
    self.init(status: status, reason: reason, output: output)
  }
}


extension Process {
  
  // Function to run a shell command and capture its output
  @discardableResult
  static func runShellCommand(executableBasePath : String = "/usr/bin/env", _ command: String, arguments: [String] = [], accceptableStatus: @Sendable @escaping (Int) -> Bool = {$0 == 0}) async throws -> ShellOutput {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: executableBasePath)
    process.arguments = [command] + arguments
    
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
      
      print(process.terminationReason.rawValue)
      print(process.terminationStatus)
      
      let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
      let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
      
      let outputString = String(decoding: outputData, as: UTF8.self)
      let errorString = String(decoding: errorData, as: UTF8.self)
      
      let output =  ShellOutput(output: outputString, error: errorString)
      
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
}
   




// Example usage: Running 'brew list' to list installed Homebrew packages
//let result = runShellCommand("brew", arguments: ["list"])

@main
struct Swoop : AsyncParsableCommand {
  
  
  mutating func run() async throws {
    await print(checkNVMInstalled())
  }
}

struct Brew {
  func run() async throws {
//    let result = try await runShellCommand("brew", arguments: ["list", "-1", "--full-name"])
//    let lines =  result.output.components(separatedBy: "\n")
//      
//      print(lines.count)
//      print(lines)
    
  }
}

struct Verify : AsyncParsableCommand {
  
  
  func run() async throws {
    // verify nvm is install
      // verify brew is install
      // install nvm

    // verify mint is install
      // verify brew is install
      // install mint

    // verify brew is install
      // install homebrew

    // verify xcodegen is install [brew vs mint]
      // verify mint or brew is install

    // verify docker is install [brew vs link]
      // verify brew is install?

    // verify prerequisites are installed for postgresdb
      // verify docker is install

    // verify prerequisites are installed for server
      // verify prerequisites are installed for postgresdb
      // setup environment

    // verify prerequisites are installed for app
      // verify xcodegen is install
      // verify Xcode Version

    // verify prerequisites are installed for web site
      // verify brew is install
  }
}
