import Foundation
import ProcessExtensions

enum Docker {
  struct Database: Action {
    let shellProfile: ShellProfile
    func run() async throws {
      print("Starting Database...")
      _ = try await Process.run(
        with: shellProfile.interperter, inProfile: self.shellProfile.profilePath,
        command: "docker compose up db -d")
    }
  }
}
