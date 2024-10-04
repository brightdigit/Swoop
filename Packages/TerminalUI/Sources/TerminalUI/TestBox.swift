public struct TextBox: TerminalContent {
  public var desiredSize: WindowSize? {
    return WindowSize(columns: 3, rows: 3, width: 0, height: 0)
  }
  
  public func render<View>(to view: inout View) where View: TerminalView {
    guard let windowSize: WindowSize = view.windowSize else {
      return
    }
    guard windowSize.columns > 0, windowSize.rows > 0 else {
      return
    }
    for x in 1 ... windowSize.columns {
      for y in 1 ... windowSize.rows {
        let character: Character
        if x == 1 || y == 1 || x == windowSize.columns - 1 || y == windowSize.rows - 1 {
          character = "="
        } else {
          character = "0"
        }

        view.put(character: character, at: Position(x: x, y: y))
      }
    }
  }

  public func write<Stream>(to stream: inout Stream, within size: WindowSize) where Stream: TextOutputStream {
    let border: String = String([Character].init(repeating: Character("-"), count: size.columns))
    let sides = "-" + String([Character].init(repeating: Character("0"), count: size.columns - 2)) + "-"
    let body = [String](repeating: sides, count: size.rows - 2).joined(separator: "")
    print(border, terminator: "", to: &stream)
    print(body, terminator: "", to: &stream)
    print(border, terminator: "", to: &stream)
  }

  public init() {}
}
