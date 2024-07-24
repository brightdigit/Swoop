
import Foundation

enum NodeVersionManager {
  static let commandName = "nvm"
  
  struct RunInstall : Action {
    let profile : ShellProfile
    func run() async throws {
      try await Process.run(with: profile.interperter, inProfile: profile.profilePath, command: "nvm install", currentDirectoryURL: URL(filePath: "Web"))
    }
  }
  
  struct Verify : Action {
    let profile : ShellProfile
    
    func run() async throws {
      let result : ShellOutput
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
