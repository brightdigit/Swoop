import Foundation

public struct ShellProfile: Codable, Sendable {
  public init(interperter: String, profilePath: String) {
    self.interperter = interperter
    self.profilePath = profilePath
  }

  public let interperter: String
  public let profilePath: String
}
