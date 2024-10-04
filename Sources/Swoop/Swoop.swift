import ArgumentParser
import ProcessExtensions

@main
struct Swoop: AsyncParsableCommand {
  let shellProfile: ShellProfile = .init(interperter: "/bin/zsh", profilePath: "~/.zshrc")


  static let configuration: CommandConfiguration = CommandConfiguration(
    subcommands: [Server.self]
  )
}

struct Server: AsyncParsableCommand {
  
}

struct App : AsyncParsableCommand {
  
}
