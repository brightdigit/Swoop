public enum TerminalEdge: Int8 {
  case top = 1
  case leading = 2
  case bottom = 4
  case trailing = 8

  public struct Set: OptionSet {
    // swiftlint:disable nesting
    public typealias Element = TerminalEdge.Set
    public typealias ArrayLiteralElement = TerminalEdge.Set.Element
    // swiftlint:enable nesting

    public init(rawValue: TerminalEdge.RawValue) {
      self.rawValue = rawValue
    }

    public let rawValue: TerminalEdge.RawValue

    public static let top = Element(.top)
    public static let leading = Element(.leading)
    public static let bottom = Element(.bottom)
    public static let trailing = Element(.trailing)
    public static let horizontal = Element(rawValue: leading.rawValue + trailing.rawValue)
    public static let vertical = Element(rawValue: top.rawValue + bottom.rawValue)
    public static let all = Element(rawValue: top.rawValue + bottom.rawValue + leading.rawValue + trailing.rawValue)

    public init(_ edge: TerminalEdge) {
      rawValue = edge.rawValue
    }
  }
}
