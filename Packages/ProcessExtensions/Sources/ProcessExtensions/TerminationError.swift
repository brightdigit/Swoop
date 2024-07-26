public struct TerminationError: Error {
  private init(status: Int, reason: Int, output: ShellOutput) {
    self.status = status
    self.reason = reason
    self.output = output
  }

  public let status: Int
  public let reason: Int
  public let output: ShellOutput

  init?(
    status: Int, reason: Int, output: ShellOutput,
    accceptableStatus: @Sendable @escaping (Int) -> Bool
  ) {
    let statusFailed = accceptableStatus(status)

    guard !statusFailed || reason != 1 else {
      return nil
    }

    self.init(status: status, reason: reason, output: output)
  }
}
