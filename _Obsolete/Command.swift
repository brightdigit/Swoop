protocol Action: Sendable {
  func run() async throws
}
