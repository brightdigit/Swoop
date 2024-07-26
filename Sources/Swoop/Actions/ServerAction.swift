//
//  ServerAction.swift
//  Swoop
//
//  Created by Leo Dion on 7/23/24.
//
import Foundation
import PathKit
import ProcessExtensions
import ProjectSpec
import Version
import XcodeGenKit
import XcodePilot
import XcodeProj

struct ServerAction: DependenciesCommand {
  let shellProfile: ShellProfile
  let dependencies: [any Action]

  init(shellProfile: ShellProfile) {
    self.shellProfile = shellProfile
    self.dependencies = [
      XcodeGenAction(),
      Docker.Database(shellProfile: self.shellProfile),
    ]
  }

  func execute() async throws {
    print("Opening Xcode...")

    guard let application = XcodeApp(filePath: "/Applications/Xcode-beta.app") else {
      throw InternalError.missingEnvironmentVariable("/Applications/Xcode-beta.app")
    }
    let swiftPackageURL = URL(filePath: "Bitness.xcodeproj")
    let workspace = try await application.openWorkspaceDocument(at: swiftPackageURL)
    try await workspace.debug(
      scheme: "bitnessd",

      runDestination: .init(arch: "arm64e", platform: "macOS")
    )

    print("Running Server...")
  }
}
