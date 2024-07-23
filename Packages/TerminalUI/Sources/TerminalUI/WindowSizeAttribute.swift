#if os(Linux)
  import Glibc
  // swiftlint:disable:next identifier_name
  public let WindowSizeAttribute = UInt(TIOCGWINSZ)
#else
  // swiftlint:disable:next identifier_name
  public let WindowSizeAttribute = TIOCGWINSZ
  import Darwin
#endif
