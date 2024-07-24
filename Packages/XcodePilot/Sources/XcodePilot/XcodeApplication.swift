//
//  XcodeApplication.swift
//  XcodePilot
//
//  Created by Leo Dion on 7/24/24.
//

public import Foundation
@preconcurrency import XcodeScriptingBridge
@preconcurrency import ScriptingBridge



public struct XcodeWorkspaceDocument : Sendable {
  let app: XcodeApp
  let document : XcodeScriptingBridge.XcodeWorkspaceDocument
  
  public func debug (
    scheme: String,
    runDestinationSpecifier: String,
    skipBuilding: Bool = false,
    commandLineArguments: [String] = [],
    environmentVariables: [String : String] = [:]
  ) async throws {
    
    
    let scheme = try await Task {
      let start = Date()
      while start.timeIntervalSinceNow < 30 {
        if let scheme = self.document.schemes?.object(withName: scheme) as? SBObject {
          return scheme as XcodeScheme
        }
        try await Task.sleep(for: .seconds(1))
      }
      throw PilotError.cannotFindScheme(scheme)
    }.value
    
    let runDestinations = document.runDestinations?.compactMap({
      $0 as? SBObject
    }).map{
      $0 as XcodeRunDestination
    }
    
    if let runDestinations {
      
      for runDestination in runDestinations {
        print(runDestination.name)
        //print(runDestination.id)
        print(runDestination.architecture)
        print(runDestination.companionDevice?.deviceIdentifier)
        print(runDestination.device?.deviceIdentifier)
        print(runDestination.platform)
      }
    }
    print("Scheme found.")
    dump(scheme)
    let result = self.document.debugScheme?(
      scheme.name!,
      runDestinationSpecifier: runDestinationSpecifier,
      skipBuilding: skipBuilding,
      commandLineArguments: commandLineArguments,
      environmentVariables: environmentVariables
    )
    
    if let result {
      let result = result as XcodeSchemeActionResult
      print("Result found.")
      dump(result)
      print(result.status?.rawValue)
      print(result.errorMessage)
    }
  }
}

enum PilotError : Error {
  case invalidWorkspaceDocument
  case cannotFindScheme(String)
}

public struct XcodeApp : Sendable {
  let xcode : XcodeApplication
  
  public init?(filePath: String) {
    self.init(applicationURL: .init(filePath: filePath))
  }
  
  public init?(applicationURL : URL) {
    guard let application = SBApplication(url: applicationURL) else {
      return nil
    }
    self.xcode = application as XcodeApplication
  }
  
  public func openWorkspaceDocument (at url: URL) async throws -> XcodePilot.XcodeWorkspaceDocument {
    _ = xcode.open?(url.standardizedFileURL)
    guard let document = xcode.documents?.object(withName: url.lastPathComponent) as? XcodeScriptingBridge.XcodeWorkspaceDocument else {
      throw PilotError.invalidWorkspaceDocument
    }
    return .init(app: self, document: document)
  }
}
