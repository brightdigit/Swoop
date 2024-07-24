//
//  ServerAction.swift
//  Swoop
//
//  Created by Leo Dion on 7/23/24.
//
import Foundation
import XcodeGenKit

struct XcodeWorkspaceDocument {
  
}
struct XcodeApplication {
  func openWorkspaceDocument (at url: URL) async throws -> XcodeWorkspaceDocument {
    
  }
}

struct XcodeGenAction : Action {
  func run() async throws {
    //XcodeGenKit.ProjectGenerator(project: .init(path: <#T##Path#>))
  }
  
  
}
struct ServerAction : ListAction {
  var dependencies: [any Action] = [
    
  ]
  func execute() async throws {
    let application = XcodeApplication()
    let swiftPackageURL = URL(filePath: "Packages/Bitness/Package.swift")
    application.openWorkspaceDocument(at: <#T##<<error type>>#>)
  }
}
