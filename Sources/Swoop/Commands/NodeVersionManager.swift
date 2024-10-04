//
//  NodeVersionManager.swift
//  Swoop
//
//  Created by Leo Dion on 10/4/24.
//

import Foundation
import ArgumentParser
import ProcessExtensions

enum NodeVersionManager {
  struct Command: AsyncParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
     commandName: "nvm",
      subcommands: [Verify.self, Install.self, Run.self]
    )
  }
  
  struct Verify : AsyncParsableCommand {
    func run() async throws {
      let result: ShellOutput
      result = try await Process.run(
        with: Swoop.shellProfile.interperter,
        inProfile: Swoop.shellProfile.profilePath,
        command: "command -v nvm"
      )
      guard !result.output.isEmpty else {
        throw ActionError.missingInstallation
      }
    }
  }
  
  struct Install : AsyncParsableCommand {
    func run() async throws {
      do {
        try await Project.Verify().run()
        return
      } catch is ActionError {
       
      }
      print("Running npm Install...")
      let command = """
        nvm use
        npm install
        """
      try await Process.run(
        with: Swoop.shellProfile.interperter,
        inProfile: Swoop.shellProfile.profilePath,
        command: command,
        currentDirectoryURL: URL(filePath: "Web")
      )
    }
  }
  
  struct Run : AsyncParsableCommand {
    @Argument var command: String = "dev"
   
    func run() async throws {
      print("Running npm run dev...")
      try createDirectoryIfNotExists(at: URL(filePath: ".swoop"))

      let outputFile = relativePath(
        from: URL(filePath: "Web"), to: URL(filePath: ".swoop/npm-run.log"))

      let command = """
        nvm use
        npm run dev > \(outputFile!) 2>&1 &
        echo $!
        """
      let output = try await Process.run(
       with: Swoop.shellProfile.interperter,
       inProfile: Swoop.shellProfile.profilePath,
        command: command,
        currentDirectoryURL: URL(filePath: "Web")
      )

      let pid = output.output.components(separatedBy: .newlines).compactMap {
        Int($0)
      }.last

      try pid?.description.write(toFile: ".swoop/npm-run.pid", atomically: true, encoding: .utf8)
    }
  }
}
