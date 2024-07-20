public protocol TerminalView {
  func hideCursor()
  func put(character: Character, at position: Position)
  var windowSize: WindowSize? { get }
}
