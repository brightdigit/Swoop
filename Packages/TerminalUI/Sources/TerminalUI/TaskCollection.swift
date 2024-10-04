public class TaskCollection: TaskDelegate {
  public weak var delegate: TaskCollectionDelegate?
  public func taskUpdated(_ task: Task) {
    delegate?.tasks(self, updatedFromSource: task)
  }

  public init(tasks: [Task]) {
    self.tasks = tasks
    for task in tasks {
      task.delegate = self
    }
  }

  public convenience init(count: Int) {
    let tasks = (0 ..< count).map { _ in
      Task()
    }

    self.init(tasks: tasks)
  }

  public let tasks: [Task]
}

extension TaskCollection {
  public func start() {
    delegate?.tasks(self, updatedFromSource: nil)
    for task in tasks {
      task.start()
    }
  }

  public var progress: Double {
    return tasks.map { $0.progress }.reduce(0, +) / Double(tasks.count)
  }
}
