// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftTUI

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
