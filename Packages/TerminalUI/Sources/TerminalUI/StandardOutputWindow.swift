import Foundation

public class StandardOutputWindow: TerminalWindow {
  var stream = StandardOutputStream()
  let sigwinchSrc = DispatchSource.makeSignalSource(signal: SIGWINCH, queue: .main)

  public init() {
    var winsizeObj = winsize()
    if ioctl(STDOUT_FILENO, WindowSizeAttribute, &winsizeObj) == 0 {
      windowSize = WindowSize(winsize: winsizeObj)
    }

    sigwinchSrc.setEventHandler {
      var winsizeObj = winsize()
      if ioctl(STDOUT_FILENO, WindowSizeAttribute, &winsizeObj) == 0 {
        self.windowSize = WindowSize(winsize: winsizeObj)
      }
    }
  }

  public func clear() {
    stream.escapeWith(code: "[2J")
  }

  public func flush() {
    fflush(stdout)
  }

  public func hideCursor() {
    stream.escapeWith(code: "[?25l")
  }

  public func put(character: Character, at position: Position) {
    stream.escapeWith(code: "[\(position.y);\(position.x)H")
    stream.write(String(character))
  }

  public var windowSize: WindowSize?

  public func initialize() {
    sigwinchSrc.resume()
  }
}
