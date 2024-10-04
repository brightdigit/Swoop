//
//  Project.swift
//  Swoop
//
//  Created by Leo Dion on 10/4/24.
//

import Foundation
import ArgumentParser
import Version
import PathKit
import ProjectSpec
import XcodeProj
import XcodeGenKit

enum Project {
  
   struct Command: AsyncParsableCommand {
     static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "project",
       subcommands: [Install.self]
     )
   }
  static func outputFiles () throws -> [String] {
    let version: Version = .init("2.42.0")!
    let specLoader = SpecLoader(version: version)
    let project: ProjectSpec.Project

    let variables: [String: String] = ProcessInfo.processInfo.environment
    let projectSpecPath: Path = "project.yml"

    let projectDirectory = projectSpecPath.parent()
    project = try specLoader.loadProject(
      path: projectSpecPath, projectRoot: nil, variables: variables)

    // validate project dictionary
    //  do {
    return [projectDirectory + "\(project.name).xcodeproj"].map{$0.string}
  }
  struct Verify : AsyncParsableCommand {
    func run() async throws {
      let result = try Project.outputFiles().allSatisfy{
        FileManager.default.fileExists(atPath: $0)
      }
      
      guard result else {
        throw ExitCode(1)
      }
    }
  }
  
  struct Install : AsyncParsableCommand {
    func run() async throws {
      let version: Version = .init("2.42.0")!
      let specLoader = SpecLoader(version: version)
      let project: ProjectSpec.Project

      let variables: [String: String] = ProcessInfo.processInfo.environment
      let projectSpecPath: Path = "project.yml"

      project = try specLoader.loadProject(
        path: projectSpecPath, projectRoot: nil, variables: variables)

      let projectDirectory = projectSpecPath.parent()

      try specLoader.validateProjectDictionaryWarnings()
      let projectPath = projectDirectory + "\(project.name).xcodeproj"

      let projectExists = XcodeProj.pbxprojPath(projectPath).exists
      try project.validateMinimumXcodeGenVersion(version)
      try project.validate()
      let fileWriter = FileWriter(project: project)
      try fileWriter.writePlists()
      let xcodeProject: XcodeProj
      let projectGenerator = ProjectGenerator(project: project)

      let userName = ProcessInfo.processInfo.userName

      xcodeProject = try projectGenerator.generateXcodeProject(
        in: projectDirectory, userName: userName)
      try fileWriter.writeXcodeProject(xcodeProject, to: projectPath)
    }
  }
}
