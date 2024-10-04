//
//  App.swift
//  Swoop
//
//  Created by Leo Dion on 10/4/24.
//

import Foundation
import ArgumentParser
import XcodePilot




struct App : AsyncParsableCommand {
  struct Command: AsyncParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
      commandName: "app",
      subcommands: [Install.self, Run.self]
    )
  }
  
  
  struct Install : AsyncParsableCommand {
    func run() async throws {
      do {
        try await Project.Verify().run()
      } catch is ExitCode {
        try await Project.Install().run()
      }
    }
  }
  
  struct Run : AsyncParsableCommand {
    func run() async throws {
      try await Install().run()
      guard let application = XcodeApp(filePath: "/Applications/Xcode.app") else {
        throw InternalError.missingEnvironmentVariable("/Applications/Xcode.app")
      }
      let swiftPackageURL = URL(filePath: "Bitness.xcodeproj")
      let workspace = try await application.openWorkspaceDocument(at: swiftPackageURL)
      try await workspace.debug(
        scheme: "Bitness",
        //, id:13D6A13B-5CEF-4F25-8F24-8EBE5364E17F, OS:18.0, name:iPhone 15 Pro
        runDestination: .init( platform: "iOS Simulator", name: "iPhone 15 Pro", OS: "18.0")
      )
    }
  }
}
