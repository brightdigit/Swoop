   
import Foundation

enum Docker {
  struct Database : Command {
    func run() async throws {
      try await Process.runShellCommand("docker", arguments: ["compose", "up", "db", "-d"])
    }
  }
}
