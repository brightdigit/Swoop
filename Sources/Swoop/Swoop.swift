
import Foundation
import ArgumentParser

import Foundation

// Function to run a shell command and capture its output
func runShellCommand(_ command: String, arguments: [String] = []) async throws -> (output: String?, error: String?) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
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
//        print("Failed to run command: \(error)")
//        return (nil, error.localizedDescription)
    }
    
    process.waitUntilExit()
    
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    
    let outputString = String(data: outputData, encoding: .utf8)
    let errorString = String(data: errorData, encoding: .utf8)
    
    continuation.resume(returning: (outputString, errorString))
  }
  
   
}

// Example usage: Running 'brew list' to list installed Homebrew packages
//let result = runShellCommand("brew", arguments: ["list"])

@main
struct Swoop : AsyncParsableCommand {
  
  
  mutating func run() async throws {
    let result = try await runShellCommand("brew", arguments: ["list", "-1", "--full-name"])
    if let lines =  result.output?.components(separatedBy: "\n") {
      
      print(lines.count)
      print(lines)
    }
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
