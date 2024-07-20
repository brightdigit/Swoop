extension TextOutputStream {
  public mutating func escapeWith(code: String) {
    write("\u{1B}\(code)")
  }
}
