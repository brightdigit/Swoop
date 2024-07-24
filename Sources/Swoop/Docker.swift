import ProcessExtensions
import Foundation

enum Docker {
  struct Database : Action {
    let shellProfile : ShellProfile
    func run() async throws {
      _ = try await Process.run(with: shellProfile.interperter, inProfile: self.shellProfile.profilePath, command: "docker compose up db -d")
    }
  }
}
