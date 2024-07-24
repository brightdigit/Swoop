//
//  XcodeApplication.swift
//  XcodePilot
//
//  Created by Leo Dion on 7/24/24.
//

public import Foundation
import ProcessExtensions
@preconcurrency import XcodeScriptingBridge
@preconcurrency import ScriptingBridge

//public struct RunDestinationQuery : Sendable {
//  public init(id: String? = nil, name: String? = nil, platform: String? = nil, architecture: String? = nil) {
//    self.id = id
//    self.name = name
//    self.platform = platform
//    self.architecture = architecture
//  }
//  
//  let id : String?
//  let name : String?
//  let platform : String?
//  let architecture: String?
//}

//extension XcodeRunDestination {
//  var specifier : String {
//    let dictionary = [
//      "platform" : self.platform,
//      "arch" : self.architecture,
//      "id" : self.device?.deviceIdentifier ?? self.companionDevice?.deviceIdentifier,
//      "name" : self.name
//    ].compactMapValues{$0}
//    //"platform:macOS, arch:arm64e, id:00008112-00124531223BC01E, name:My Mac"
//    return dictionary.map{
//      [$0.key, $0.value].joined(separator: "=")
//    }.joined(separator: ", ")
//  }
//}

public struct RunDestination : Sendable {
  public init(arch: String, platform: String) {
    self.arch = arch
    self.platform = platform
  }
  
  let arch: String
  let platform : String
}

// Define a structure to represent a destination
struct Destination : CustomStringConvertible {
  var description: String {
          var components: [String] = ["platform:\(platform)"]
          
          if let arch = arch {
              components.append("arch:\(arch)")
          }
          
          if let variant = variant {
              components.append("variant:\(variant)")
          }
          
          if let id = id {
              components.append("id:\(id)")
          }
          
          
          components.append("name:\(name)")
          
          return components.joined(separator: ", ")
      }
  internal init(platform: String, arch: String? = nil, id: String? = nil, name: String, variant: String? = nil) {
    self.platform = platform
    self.arch = arch
    self.id = id
    self.name = name
    self.variant = variant
  }
  
  private init?(platform: String?, arch: String? = nil, id: String? = nil, name: String?, variant: String? = nil) {
    guard let name, let platform else {
      return nil
    }
    self.platform = platform
    self.arch = arch
    self.id = id
    self.name = name
    self.variant = variant
  }
  
  static let destinationPrefix = "{ platform:"
  
  // Function to parse the output and create Destination structures
  static func parseFrom( output: String) -> [Destination] {
      var destinations = [Destination]()
      let lines = output.components(separatedBy: .newlines)
      let destinationPrefix = "{ platform:"
      
      for line in lines {
          guard line.contains(destinationPrefix) else { continue }
          
          // Clean up the line and split by comma
          let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst().dropLast()
          let components = cleanLine.split(separator: ",")
          
          var platform = ""
          var arch: String? = nil
          var id: String? = nil
          var name = ""
          var variant: String? = nil
          
          for component in components {
              let keyValue = component.split(separator: ":").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
              if keyValue.count == 2 {
                  let key = keyValue[0]
                  let value = keyValue[1]
                  
                  switch key {
                  case "platform":
                      platform = value
                  case "arch":
                      arch = value
                  case "id":
                      id = value
                  case "name":
                      name = value
                  case "variant":
                      variant = value
                  default:
                      break
                  }
              }
          }
          
          let destination = Destination(platform: platform, arch: arch, id: id, name: name, variant: variant)
          destinations.append(destination)
      }
      
      return destinations
  }
  internal init?(line: String) {
    guard line.contains(Self.destinationPrefix) else { return nil }
    
    // Clean up the line and split by comma
    let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst().dropLast()
    let components = cleanLine.split(separator: ",")
    
    var platform: String? = nil
    var arch: String? = nil
    var id: String? = nil
    var name: String? = nil
    var variant: String? = nil
    
    for component in components {
        let keyValue = component.split(separator: ":").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        if keyValue.count == 2 {
            let key = keyValue[0]
            let value = keyValue[1]
            
            switch key {
            case "platform":
                platform = value
            case "arch":
                arch = value
            case "id":
                id = value
            case "name":
                name = value
            case "variant":
                variant = value
            default:
                break
            }
        }
    }
    
    self.init(platform: platform, arch: arch, id: id, name: name, variant: variant)
  }
  
   let platform: String
   let arch: String?
   let id: String?
   let name: String
   let variant: String?
}


public struct XcodeWorkspaceDocument : Sendable {

  
  internal init(app: XcodeApp, document: any XcodeScriptingBridge.XcodeWorkspaceDocument)  {
    self.app = app
    self.document = document
  }
  
  let app: XcodeApp
  let document : XcodeScriptingBridge.XcodeWorkspaceDocument
  
  public func debug (
    scheme: String,
    runDestination destination: RunDestination,
    skipBuilding: Bool = false,
    commandLineArguments: [String] = [],
    environmentVariables: [String : String] = [:]
  ) async throws {
    
    async let runDestination = try await Task{
      let shellOutput = try await Process.execute(
        "xcodebuild",
        arguments: ["-project \(document.file!.lastPathComponent)","-scheme \(scheme)", "-showdestinations"],
        currentDirectoryURL: document.file?.deletingLastPathComponent()
      )
      
      
      
      let destinations = Destination.parseFrom(output: shellOutput.output)
      
      let destination = destinations.first {
        destination.arch == $0.arch && destination.platform == $0.platform
      }
      
      guard let destination else {
        fatalError()
      }
      
      return destination
    }.value
    
    
    
    let xcodeScheme = try await Task {
      let start = Date()
      while start.timeIntervalSinceNow < 30 {
        if let scheme = self.document.schemes?.object(withName: scheme) as? SBObject {
          return scheme as XcodeScheme
        }
        try await Task.sleep(for: .seconds(1))
      }
      throw PilotError.cannotFindScheme(scheme)
    }.value
    
    
    
    let result = try await self.document.debugScheme?(
      scheme,
      runDestinationSpecifier: runDestination.description,
      skipBuilding: skipBuilding,
      commandLineArguments: commandLineArguments,
      environmentVariables: environmentVariables
    )
    
    if let result {
      let result = result as XcodeSchemeActionResult
      print("Result found.")
      
      print(result.buildErrors)
      print(result.buildLog)
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
    return await .init(app: self, document: document)
  }
}
