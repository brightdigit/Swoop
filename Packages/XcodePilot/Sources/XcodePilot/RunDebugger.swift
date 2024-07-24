// The Swift Programming Language
// https://docs.swift.org/swift-book
public import Foundation
import XcodeScriptingBridge
import ScriptingBridge
public func runDebugger(using appURL: URL, projectPath: String, schemeName: String, runDestinationSpecifier: String) {
  guard let application = SBApplication(url: appURL) else {
    exit(1)
  }
  
  let xcode = application as XcodeApplication
  let projectURL = URL(filePath: projectPath)
  let openResult = xcode.open?(projectPath)
  
  guard let elements = xcode.documents?.get() else {
    exit(1)
  }
  
  let document =
  xcode.documents?.object(withName: projectURL.lastPathComponent) as? XcodeScriptingBridge.XcodeWorkspaceDocument
  
  //guard let bitnessdScheme = document?.schemes?.object(withName: "bitnessd") as? XcodeScheme else {
  //  exit(1)
  //}
  guard let document = document else {
    exit(1)
  }
  guard let runDestinations = document.runDestinations else {
    exit(1)
  }
  for runDestination in runDestinations {
    guard let destination = runDestination as? XcodeRunDestination else {
      exit(1)
    }
    //  print(destination.name)
    //  dump(destination)
  }
  
  let result = document.debugScheme?(
    schemeName,
    runDestinationSpecifier: runDestinationSpecifier,
    skipBuilding: true, commandLineArguments: [], environmentVariables: [])
}
