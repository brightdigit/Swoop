//
//  Docker.swift
//  Swoop
//
//  Created by Leo Dion on 10/4/24.
//

import Foundation
import ArgumentParser

enum Docker {
  
   struct Command: AsyncParsableCommand {
     static let configuration: CommandConfiguration = CommandConfiguration(
      commandName: "docker",
       subcommands: [Verify.self, Install.self, Run.self]
     )
   }
   
   struct Verify : AsyncParsableCommand {
     
   }
   
   struct Install : AsyncParsableCommand {
     
   }
   
   struct Run : AsyncParsableCommand {
     
     func run() async throws {
       
         print("Starting Database...")
         _ = try await Process.run(
          with: Swoop.shellProfile.interperter, inProfile: Swoop.shellProfile.profilePath,
           command: "docker compose up db -d")
     }
   }
}
