struct PaddingView<View: TerminalView>: TerminalView {
  let edges: TerminalEdge.Set
  let length: Int
  let parent: View

  func hideCursor() {
    parent.hideCursor()
  }

  func put(character: Character, at position: Position) {
    guard let windowSize = self.windowSize else {
      return
    }

    guard position.x < windowSize.columns, position.y < windowSize.rows else {
      return
    }

    let xOffset = edges.contains(.leading) ? length : 0
    let yOffset = edges.contains(.top) ? length : 0
    let transformedPosition = Position(x: position.x + xOffset, y: position.y + yOffset)
    parent.put(character: character, at: transformedPosition)
  }

  public var windowSize: WindowSize? {
    return parent.windowSize?.padding(edges, length)
  }
}

public extension TerminalView {
  func padding(_ edges: TerminalEdge.Set = .all, _ length: Int) -> some TerminalView {
    PaddingView(edges: edges, length: length, parent: self)
  }
}
