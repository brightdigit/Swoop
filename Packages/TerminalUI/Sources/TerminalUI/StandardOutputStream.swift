#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

public struct StandardOutputStream: TextOutputStream {
  public mutating func write(_ string: String) { fputs(string, stdout) }
}
