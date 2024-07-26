import ArgumentParser
import ProcessExtensions

@main
struct Swoop: AsyncParsableCommand {
  let shellProfile: ShellProfile = .init(interperter: "/bin/zsh", profilePath: "~/.zshrc")

  mutating func run() async throws {
    let action = WebAction(shellProfile: shellProfile)
    try await action.run()
  }
}
