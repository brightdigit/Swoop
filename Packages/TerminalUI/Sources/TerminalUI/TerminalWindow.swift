public protocol TerminalWindow: TerminalView {
  func clear()
  func flush()
  func initialize()
}
