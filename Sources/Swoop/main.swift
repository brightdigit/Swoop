// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftTUI

import XcodePilot

protocol Command : Sendable {
  func run () async throws
}

protocol DependingCommand : Command {
  var dependencies : [Command] { get }
  func onDependenciesComplete () async throws
}


struct XcodeDebug : Command {
  func run() async throws {
    
  }
  
  
}

extension DependingCommand {
  func run() async throws {
    try await withThrowingTaskGroup(of: Void.self) { group in
      for dependency in self.dependencies {
        group.addTask {
          try await dependency.run()
        }
      }
      
      try await group.waitForAll()
    }
    try await self.onDependenciesComplete()
  }
}
struct TerminalView : View {
  var body : some View {
    VStack{
      Button("Run Server") {
        runDebugger(
          using: URL(filePath: "/Applications/Xcode-beta.app"),
          projectPath: "/Users/leo/Documents/Projects/Bitness/Bitness.xcodeproj",
          schemeName: "bitnessd",
          runDestinationSpecifier: "platform:macOS, arch:arm64e, id:00008112-00124531223BC01E, name:My Mac")
      }
      
      Button("Quit") {
        exit(0)
      }
    }
  }
  
}

Application(rootView: TerminalView()).start()
//let appURL = URL(filePath: "/Applications/Xcode-beta.app")
//let projectPath = "/Users/leo/Documents/Projects/Bitness/Bitness.xcodeproj"
//let runDestinationSpecifier = "platform:macOS, arch:arm64e, id:00008112-00124531223BC01E, name:My Mac"
//let schemeName = "bitnessd"

//runDebugger(using: appURL, projectPath: projectPath, schemeName: schemeName, runDestinationSpecifier: runDestinationSpecifier)
