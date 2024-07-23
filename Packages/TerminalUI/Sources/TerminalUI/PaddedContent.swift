public struct PaddedContent<Content: TerminalContent>: TerminalContent {
  
  public var desiredSize: WindowSize? {
    
    var rowFactor = 0
    if edges.contains(.top) {
      rowFactor += 1
    }
    if edges.contains(.bottom) {
      rowFactor += 1
    }

    var columnFactor = 0
    if edges.contains(.leading) {
      columnFactor += 1
    }
    if edges.contains(.trailing) {
      columnFactor += 1
    }
    
    let bodySize = body.desiredSize ?? WindowSize(columns: 0, rows: 0, width: 0, height: 0)
    return WindowSize(columns: bodySize.columns + columnFactor * length, rows: bodySize.rows + rowFactor * length, width: 0, height: 0)
  }
  
  let edges: TerminalEdge.Set
  let length: Int
  public let body: Content

  public func render<View>(to view: inout View) where View: TerminalView {
    var view = view.padding(edges, length)
    body.render(to: &view)
  }

  public init(edges: TerminalEdge.Set, length: Int, _ body: Content) {
    self.edges = edges
    self.length = length
    self.body = body
  }
}
