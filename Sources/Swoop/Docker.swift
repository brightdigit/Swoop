   
import Foundation

enum Docker {
  struct Database : Action {
    func run() async throws {
      try await Process.runShellCommand("docker", arguments: ["compose", "up", "db", "-d"])
    }
  }
}
