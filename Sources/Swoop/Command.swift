
protocol Command : Sendable {
  func run () async throws
}
