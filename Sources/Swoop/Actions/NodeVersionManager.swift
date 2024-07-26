import Foundation
import ProcessExtensions

enum NodeVersionManager {
  static let commandName = "nvm"

  struct RunInstall: DependenciesCommand {
    let profile: ShellProfile
    let dependencies: [any Action]
    init(profile: ShellProfile) {
      self.profile = profile
      self.dependencies = [
        NodeVersionManager.Verify(profile: profile)
      ]
    }
    func execute() async throws {
      print("Running nvm Install...")
      try await Process.run(
        with: profile.interperter, inProfile: profile.profilePath, command: "nvm install",
        currentDirectoryURL: URL(filePath: "Web"))
    }
  }

  struct Verify: Action {
    let profile: ShellProfile

    func run() async throws {
      let result: ShellOutput
      result = try await Process.run(
        with: profile.interperter,
        inProfile: profile.profilePath,
        command: "command -v nvm"
      )
      guard !result.output.isEmpty else {
        throw ActionError.missingInstallation
      }
    }
  }
}
