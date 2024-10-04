import ArgumentParser
import Foundation
import ProjectSpec
import Version
import ProcessExtensions
import XcodeGenKit
import PathKit
import XcodeProj
import XcodePilot

@main
struct Swoop: AsyncParsableCommand {
  static let shellProfile: ShellProfile = .init(
    interperter: "/bin/zsh",
    profilePath: "~/.zshrc"
  )


  static let configuration: CommandConfiguration = CommandConfiguration(
    subcommands: [
      Server.Command.self,
      App.Command.self,
      Project.Command.self,
      Docker.Command.self,
      Web.Command.self,
      NodePackageManager.Command.self,
      NodeVersionManager.Command.self
    ]
  )
}







