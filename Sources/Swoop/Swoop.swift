import ArgumentParser

@main
struct Swoop : AsyncParsableCommand {
  let shellProfile : ShellProfile = .init(interperter: "/bin/zsh", profilePath: "~/.zprofile")
  
  mutating func run() async throws {
    let action = ServerAction(shellProfile: shellProfile)
    try await action.run()
  }
}


struct Web : Action {
  let shellProfile : ShellProfile
  func run() async throws {
    print("Verifying nvm install...")
    do {
      try await NodeVersionManager.Verify(profile: shellProfile).run()
    } catch  ActionError.missingInstallation {
      print("missing \(NodeVersionManager.commandName)")
    }
    print("Running nvm install...")
    try await NodeVersionManager.RunInstall(profile: shellProfile).run()
    print("Running npm install...")
    try await NodePackageManager.RunInstall(profile: shellProfile).run()
    print("Starting Database...")
    try await Docker.Database(shellProfile: shellProfile).run()
    print("Starting Development Web Server...")
    try await NodePackageManager.RunCommand(profile: shellProfile).run()
  }
}
