import Foundation
import ScriptingBridge
@preconcurrency import XcodeScriptingBridge

public struct XcodeWorkspaceDocument: Sendable {

  internal init(app: XcodeApp, document: any XcodeScriptingBridge.XcodeWorkspaceDocument) {
    self.app = app
    self.document = document
  }

  let app: XcodeApp
  let document: XcodeScriptingBridge.XcodeWorkspaceDocument

  public func debug(
    scheme: String,
    runDestination destination: RunDestination,
    skipBuilding: Bool = false,
    commandLineArguments: [String] = [],
    environmentVariables: [String: String] = [:]
  ) async throws {

    async let runDestination = try await Task {

      guard let projectFileURL = document.file?.findParent(withPathExtension: "xcodeproj") else {
        fatalError()
      }

      print("Getting Destinations...")

      let shellOutput = try await Process.execute(
        "/usr/bin/xcodebuild",
        arguments: ["-project", projectFileURL.path(), "-scheme", scheme, "-showdestinations"],
        currentDirectoryURL: projectFileURL.deletingLastPathComponent()
      )

      let destinations = Destination.parseFrom(output: shellOutput.output)

      print("Parsed \(destinations.count) Destinations...")

      let destination = destinations.first {
        destination.arch == $0.arch && destination.platform == $0.platform
      }

      print("Found Destination.")

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

  }
}
