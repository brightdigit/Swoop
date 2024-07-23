
import Foundation

enum NodeVersionManager {
  static let commandName = "nvm"
  
  struct RunInstall : Command {
    let profile : ShellProfile
    func run() async throws {
      try await Process.run(with: profile.interperter, inProfile: profile.profilePath, command: "nvm install", currentDirectoryURL: URL(filePath: "Web"))
    }
  }
  
  struct Verify : Command {
    let profile : ShellProfile
    
    func run() async throws {
      let result : ShellOutput
      result = try await Process.run(
        with: profile.interperter,
        inProfile: profile.profilePath,
        command: "command -v nvm"
      )
      guard !result.output.isEmpty else {
        throw CommandError.missingInstallation
      }
    }
  }
}
