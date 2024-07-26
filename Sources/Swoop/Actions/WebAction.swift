import ProcessExtensions

struct WebAction: DependenciesCommand {
  let shellProfile: ShellProfile

  let dependencies: [any Action]

  init(shellProfile: ShellProfile) {
    self.shellProfile = shellProfile
    self.dependencies = [
      ServerAction(shellProfile: shellProfile),
      NodePackageManager.RunInstall(profile: shellProfile),
    ]
  }
  func execute() async throws {
    print("Starting Development Web Server...")
    try await NodePackageManager.RunCommand(profile: shellProfile).run()
  }
}
