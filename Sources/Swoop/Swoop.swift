
import Foundation
import ArgumentParser

import Foundation

import os.log

struct ShellProfile : Codable {
  let interperter: String
  let profilePath: String
}
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

func relativePath(from base: URL, to target: URL) -> String? {
    let basePathComponents = base.pathComponents
    let targetPathComponents = target.pathComponents
    
    // Find the common path prefix
    var commonComponentsCount = 0
    for (baseComponent, targetComponent) in zip(basePathComponents, targetPathComponents) {
        if baseComponent == targetComponent {
            commonComponentsCount += 1
        } else {
            break
        }
    }
    
    // Calculate the number of `..` needed
    let baseUniqueComponentsCount = basePathComponents.count - commonComponentsCount
    let relativePathComponents = Array(repeating: "..", count: baseUniqueComponentsCount) +
                                 targetPathComponents[commonComponentsCount...]
    
    return NSString.path(withComponents: Array(relativePathComponents))
}

func createDirectoryIfNotExists(at url: URL) throws {
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: url.path) {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}

enum NodePackageManager {
  struct RunInstall : Command {
    let profile : ShellProfile
    func run() async throws {
      let command = """
nvm use
npm install
"""
     try await Process.run(
        with: profile.interperter,
        inProfile: profile.profilePath,
        command: command,
        currentDirectoryURL: URL(filePath: "Web")
      )
    }
  }
  
  struct RunCommand : Command {
    let profile : ShellProfile
    
    func run() async throws {
      try createDirectoryIfNotExists(at: URL(filePath: ".swoop"))
      
      let outputFile = relativePath(from: URL(filePath: "Web"), to: URL(filePath: ".swoop/npm-run.log"))
      
      let command = """
nvm use
npm run dev > \(outputFile!) 2>&1 &
echo $!
"""
      let output = try await Process.run(
         with: profile.interperter,
         inProfile: profile.profilePath,
         command: command,
         currentDirectoryURL: URL(filePath: "Web")
       )

      let pid = output.output.components(separatedBy: .newlines).compactMap{
        Int($0)
      }.last
      
      try       pid?.description.write(toFile: ".swoop/npm-run.pid", atomically: true, encoding: .utf8)
    }
    
  }
}

enum NodeVersionManager : ShellCommand {
  static let commandName = "nvm"
  
  struct RunInstall : Command {
    let profile : ShellProfile
    func run() async throws {
      try await Process.run(with: profile.interperter, inProfile: profile.profilePath, command: "nvm install", currentDirectoryURL: URL(filePath: "Web"))
    }
  }
  
  struct Verify : Command {
    let profile : ShellProfile
    
    func run() async throws {
      let result : ShellOutput
      result = try await Process.run(
        with: profile.interperter,
        inProfile: profile.profilePath,
        command: "command -v nvm"
      )
      guard !result.output.isEmpty else {
        throw CommandError.missingInstallation
      }
//        if !result.output.isEmpty {
//              print("nvm is installed. Command path:\n\(result.output)")
//              return true
//        } else if !result.error.isEmpty {
//              print("Error checking nvm installation:\n\(result.error)")
//          } else {
//              print("nvm is not installed.")
//          }
//      return false
    }
  }
}

protocol ShellCommand {
  static var commandName : String { get }
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

// Function to run an nvm command
//func runNVMCommand(_ nvmCommand: String) -> (output: String?, error: String?) {
//    let shellProfile = "~/.zshrc" // Adjust to your specific zsh profile file if necessary
//    let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
//    let tempScriptURL = homeDirectory.appendingPathComponent(".run_nvm.sh")
//    
//    // Create a temporary script to source the profile and run the nvm command
//    let script = """
//    #!/bin/zsh
//    source \(shellProfile)
//    \(nvmCommand)
//    """
//    
//    // Write the script to a temporary file
//    do {
//        try script.write(to: tempScriptURL, atomically: true, encoding: .utf8)
//        // Make the script executable
//        try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: tempScriptURL.path)
//    } catch {
//        print("Failed to write or set permissions for the temporary script: \(error)")
//        return (nil, error.localizedDescription)
//    }
//    
//    // Run the temporary script
//  let result = Process.runShellCommand(tempScriptURL.path)
//    
//    // Clean up the temporary script
//    try? FileManager.default.removeItem(at: tempScriptURL)
//    
//    return result
//}

extension Process {
  
  static func run(with interpreter: String, inProfile shellProfile: String, command: String, currentDirectoryURL: URL? = nil) async throws -> ShellOutput {
    // Adjust to your specific zsh profile file if necessary
    
    let tempName = UUID().uuidString
    let tempScriptURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tempName)
    
    // Create a temporary script to source the profile and run the nvm command
    let script = """
        #!\(interpreter)
        source \(shellProfile)
        \(command)
        """
    
    // Write the script to a temporary file
    //do {
    try script.write(to: tempScriptURL, atomically: true, encoding: .utf8)
    // Make the script executable
    try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: tempScriptURL.path)
    //        } catch {
    //            print("Failed to write or set permissions for the temporary script: \(error)")
    //            return (nil, error.localizedDescription)
    //        }
    
    // Run the temporary script
    print(currentDirectoryURL?.standardizedFileURL)
    let result = try await Process.runShellCommand(tempScriptURL.path, currentDirectoryURL: currentDirectoryURL)
    
    do {
      // Clean up the temporary script
      try FileManager.default.removeItem(at: tempScriptURL)
    } catch {
      Logger(subsystem: "swoop", category: "execute").warning("Unable to delete temporary file.")
    }
    
    return result
  }
  
//  @discardableResult
//  static func run () async throws -> ShellOutput {
//    let interpreter = "/bin/zsh"
//    let command = ""
//    let shellProfile = "~/.zshrc" return try run(interpreter, shellProfile, command)
//  }
  
  // Function to run a shell command and capture its output
  @discardableResult
  static func runShellCommand(executableBasePath : String = "/usr/bin/env", _ command: String, arguments: [String] = [], currentDirectoryURL: URL? = nil, accceptableStatus: @Sendable @escaping (Int) -> Bool = {$0 == 0}) async throws -> ShellOutput {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: executableBasePath)
    process.arguments = [command] + arguments
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
      
//      print(process.terminationReason.rawValue)
//      print(process.terminationStatus)
      
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
   



enum Docker {
  struct Database : Command {
    func run() async throws {
      try await Process.runShellCommand("docker", arguments: ["compose", "up", "db", "-d"])
    }
  }
}
// Example usage: Running 'brew list' to list installed Homebrew packages
//let result = runShellCommand("brew", arguments: ["list"])

@main
struct Swoop : AsyncParsableCommand {
  let shellProfile : ShellProfile = .init(interperter: "/bin/zsh", profilePath: "~/.zshrc")
  
  mutating func run() async throws {
    print("Verifying nvm install...")
    do {
      try await NodeVersionManager.Verify(profile: shellProfile).run()
    } catch CommandError.missingInstallation {
      print("missing \(NodeVersionManager.commandName)")
    }
    print("Running nvm install...")
    try await NodeVersionManager.RunInstall(profile: shellProfile).run()
    print("Running npm install...")
    try await NodePackageManager.RunInstall(profile: shellProfile).run()
    print("Starting Database...")
    try await Docker.Database().run()
    print("Starting Development Web Server...")
    try await NodePackageManager.RunCommand(profile: shellProfile).run()
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
