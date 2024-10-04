//
//  Server.swift
//  Swoop
//
//  Created by Leo Dion on 10/4/24.
//

import Foundation
import ArgumentParser
import XcodePilot

enum Server{
 
  struct Command: AsyncParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
      commandName: "server",
      subcommands: [Verify.self, Install.self, Run.self]
    )
  }
  
  struct Verify : AsyncParsableCommand {
    
  }
  
  struct Install : AsyncParsableCommand {
    
  }
  
  struct Run : AsyncParsableCommand {
    func run() async throws {
      
      guard let application = XcodeApp(filePath: "/Applications/Xcode.app") else {
        throw InternalError.missingEnvironmentVariable("/Applications/Xcode.app")
      }
      let swiftPackageURL = URL(filePath: "Bitness.xcodeproj")
      let workspace = try await application.openWorkspaceDocument(at: swiftPackageURL)
      try await workspace.debug(
        scheme: "bitnessd",
        
        runDestination: .init(arch: "arm64e", platform: "macOS")
      )
    }
  }
}
