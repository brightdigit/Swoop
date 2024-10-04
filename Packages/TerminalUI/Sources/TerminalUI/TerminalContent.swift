import Foundation

public protocol TerminalContent {
  func render<View: TerminalView>(to view: inout View)
  
  var desiredSize : WindowSize? { get }
}

@available(OSX 10.15.0, *)
public extension TerminalContent {
  func padding(_ edges: TerminalEdge.Set = .all, _ length: Int) -> some TerminalContent {
    PaddedContent(edges: edges, length: length, self)
  }
}
