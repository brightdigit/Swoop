
@available(*, deprecated, message: "Switch to List")
protocol DependenciesCommand : Command {
  var dependencies : [any Command] { get }
  func execute() async throws
}

extension DependenciesCommand {
  func run() async throws {
    try await withThrowingTaskGroup(of: Void.self) { group in
      for dependency in self.dependencies {
        group.addTask {
          try await dependency.run()
        }
      }
      try await group.waitForAll()
    }
    try await self.execute()
  }
}
