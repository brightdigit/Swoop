//
//  Web.swift
//  Swoop
//
//  Created by Leo Dion on 10/4/24.
//

import ArgumentParser


enum Web {
  
   struct Command: AsyncParsableCommand {
     static let configuration: CommandConfiguration = CommandConfiguration(
      commandName: "web",
       subcommands: [Verify.self, Install.self, Run.self]
     )
   }
   
   struct Verify : AsyncParsableCommand {
     
   }
   
   struct Install : AsyncParsableCommand {
     
   }
   
   struct Run : AsyncParsableCommand {
     func run() async throws {
       async let npmRun: () = try {
         var npm = NodePackageManager.Run()
         try npm.run()
       }()
       
       async let serverRun: () = try {
         var server = Server.Run()
         try server.run()
       }()
       
       let _ =  try await (npmRun, serverRun)
       var nodeRun = NodePackageManager.Run()
       try await nodeRun.run()
     }
   }
}
