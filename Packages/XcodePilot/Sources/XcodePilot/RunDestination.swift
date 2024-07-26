public struct RunDestination: Sendable {
  public init(arch: String, platform: String) {
    self.arch = arch
    self.platform = platform
  }

  let arch: String
  let platform: String
}
