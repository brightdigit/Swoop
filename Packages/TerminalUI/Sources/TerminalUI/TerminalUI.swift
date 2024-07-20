import Foundation

public class TerminalUI: TaskCollectionDelegate {
  var windowSize = winsize()
  fileprivate func printData(_ collection: TaskCollection) {
    escapeWith(code: "[2J")
    escapeWith(code: "[0;0H")
    print()
    print("  Welcome to this Demo of TerminalUI!")
    print()
    print("  Here is a sample progress bar:")
    print([String](repeating: "-", count: Int(windowSize.ws_col)).joined(separator: ""))
    let length = (collection.tasks.map { $0.name }.map { $0.count }.max() ?? 0) + 1
    for task in collection.tasks {
      let paddedName = task.name.padding(toLength: length, withPad: " ", startingAt: 0)

      let paddedProgress = String(
        String(
          "\(round(task.progress * 10.0) / 10.0)%".reversed()
        ).padding(toLength: 8, withPad: " ", startingAt: 0).reversed())
      print("\t", paddedName, paddedProgress)
    }
    print([String](repeating: "=", count: Int(windowSize.ws_col)).joined(separator: ""))
    let paddedName = "Total".padding(toLength: length, withPad: " ", startingAt: 0)
    let paddedProgress = String(
      String(
        "\(round(collection.progress * 10.0) / 10.0)%".reversed()
      ).padding(toLength: 8, withPad: " ", startingAt: 0).reversed())
    print("\t", paddedName, paddedProgress)
    print([String](repeating: "-", count: Int(windowSize.ws_col)).joined(separator: ""))
    if collection.progress >= 100.0 {
      shouldKeepRunning = false
    }
  }

  public func tasks(_ collection: TaskCollection, updatedFromSource _: Any?) {
    printData(collection)
  }

  func refresh() {
    if ioctl(STDOUT_FILENO, WindowSizeAttribute, &windowSize) == 0 {
      printData(collection)
    }
  }

  var shouldKeepRunning = true
  var semaphore = DispatchSemaphore(value: 0)
  var text = "Hello, World!"
  let runLoop = RunLoop.current
  let collection = TaskCollection(count: 10)
  public init() {
    _ = ioctl(STDOUT_FILENO, WindowSizeAttribute, &windowSize)
    let sigwinchSrc = DispatchSource.makeSignalSource(signal: SIGWINCH, queue: .main)
    sigwinchSrc.setEventHandler {
      self.refresh()
    }
    sigwinchSrc.resume()
  }

  func escapeWith(code: String) {
    print("\u{1B}\(code)", terminator: "")
  }

  public func execute() {
    collection.delegate = self
    collection.start()
    while shouldKeepRunning == true,
      runLoop.run(mode: .default, before: .distantFuture) {}
  }
}
