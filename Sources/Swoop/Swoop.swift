import ArgumentParser
import ProcessExtensions

@main
struct Swoop : AsyncParsableCommand {
  let shellProfile : ShellProfile = .init(interperter: "/bin/zsh", profilePath: "~/.zshrc")
  
  mutating func run() async throws {
    let action = WebAction(shellProfile: shellProfile)
    try await action.run()
  }
}


struct WebAction : ListAction {
  let shellProfile : ShellProfile
  
  let dependencies: [any Action]
  
  init(shellProfile: ShellProfile) {
    self.shellProfile = shellProfile
    self.dependencies = [
      ServerAction(shellProfile: shellProfile),
      NodePackageManager.RunInstall(profile: shellProfile)
    ]
  }
  func execute() async throws {
//    print("Verifying nvm install...")
//    do {
//      try await NodeVersionManager.Verify(profile: shellProfile).run()
//    } catch  ActionError.missingInstallation {
//      print("missing \(NodeVersionManager.commandName)")
//    }
//    print("Running nvm install...")
//    try await NodeVersionManager.RunInstall(profile: shellProfile).run()
//    print("Running npm install...")
//    try await NodePackageManager.RunInstall(profile: shellProfile).run()
//    print("Starting Database...")
//    try await Docker.Database(shellProfile: shellProfile).run()
    print("Starting Development Web Server...")
    try await NodePackageManager.RunCommand(profile: shellProfile).run()
  }
}
