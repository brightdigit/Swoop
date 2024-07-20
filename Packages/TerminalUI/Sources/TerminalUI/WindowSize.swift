#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

public struct WindowSize {
  public let columns: Int
  public let rows: Int
  public let width: Int
  public let height: Int

  public init(winsize: winsize = winsize()) {
    columns = Int(winsize.ws_col)
    rows = Int(winsize.ws_row)
    width = Int(winsize.ws_xpixel)
    height = Int(winsize.ws_ypixel)
  }

  public init(columns: Int,
              rows: Int,
              width: Int,
              height: Int) {
    self.columns = columns
    self.rows = rows
    self.width = width
    self.height = height
  }
}

public extension WindowSize {
  func padding(_ edges: TerminalEdge.Set = .all, _ length: Int) -> WindowSize {
    let columnPixels = self.width / self.columns
    let rowPixels = self.height / self.rows

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

    let columns = self.columns - length * columnFactor
    let rows = self.rows - length * rowFactor
    let height = rowPixels * rows
    let width = columnPixels * columns

    return WindowSize(columns: columns, rows: rows, width: width, height: height)
  }
}
