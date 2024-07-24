
protocol ListAction : Action {
  var dependencies : [any Action] { get }
  func execute() async throws
}

extension ListAction {
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
