#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

import Foundation

public class TerminalController<Window: TerminalWindow, Content: TerminalContent> {
  private var shouldKeepRunning = true
  private var window: Window
  private let content: Content
  private let runLoop = RunLoop.current

  private var timer: Timer!
  public init(window: Window, content: Content) {
    // fdopen(FileHandle.standardInput.fileDescriptor, <#T##UnsafePointer<Int8>!#>)

    self.window = window
    self.content = content
    let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
      self.draw()

    })

    self.timer = timer
    runLoop.add(timer, forMode: .common)
  }

  public func run() {
    window.initialize()
    while shouldKeepRunning == true,
      runLoop.run(mode: .default, before: .distantFuture) {}
    timer.invalidate()
  }

  public func draw() {
    // stream.escapeWith(code: "[r")
    window.clear()
    // stream.escapeWith(code: "[2J")

    content.render(to: &window)
    // content.write(to: &stream, within: WindowSize(winsize: windowSize))
    // stream.escapeWith(code: "[f")
    window.hideCursor()
    // stream.escapeWith(code: "[?25l")

    window.flush()
  }
}

extension TerminalController where Window == StandardOutputWindow {
  public convenience init(content: Content) {
    self.init(window: StandardOutputWindow(), content: content)
  }
}
