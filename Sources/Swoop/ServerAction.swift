//
//  ServerAction.swift
//  Swoop
//
//  Created by Leo Dion on 7/23/24.
//
import Foundation
import ProjectSpec
import PathKit
import XcodeProj
import Version
import XcodeGenKit
import XcodePilot


struct XcodeGenAction : Action {
  func run() async throws {
    let version : Version = .init("2.42.0")!
    let specLoader = SpecLoader(version: version)
    let project: Project
    
    let variables: [String: String] = ProcessInfo.processInfo.environment
    let projectSpecPath : Path = "project.yml"
    
    project = try specLoader.loadProject(path: projectSpecPath, projectRoot: nil, variables: variables)

    let projectDirectory = projectSpecPath.parent()

    // validate project dictionary
  //  do {
        try specLoader.validateProjectDictionaryWarnings()
//    } catch {
//        warning("\(error)")
//    }

    let projectPath = projectDirectory + "\(project.name).xcodeproj"

//    let cacheFilePath = self.cacheFilePath ??
//        Path("~/.xcodegen/cache/\(projectSpecPath.absolute().string.md5)").absolute()
//    var cacheFile: CacheFile?
//
//    // generate cache
//    if useCache || self.cacheFilePath != nil {
//        do {
//            cacheFile = try specLoader.generateCacheFile()
//        } catch {
//            throw GenerationError.projectSpecParsingError(error)
//        }
//    }

    let projectExists = XcodeProj.pbxprojPath(projectPath).exists

//    // check cache
//    if let cacheFile = cacheFile,
//        projectExists,
//        cacheFilePath.exists {
//        do {
//            let existingCacheFile: String = try cacheFilePath.read()
//            if cacheFile.string == existingCacheFile {
//                info("Project \(project.name) has not changed since cache was written")
//                return
//            }
//        } catch {
//            info("Couldn't load cache at \(cacheFile)")
//        }
//    }

    // validate project
  //  do {
        try project.validateMinimumXcodeGenVersion(version)
        try project.validate()
//    } catch let error as SpecValidationError {
//        throw GenerationError.validationError(error)
//    }

    // run pre gen command
//    if let command = project.options.preGenCommand {
//        try Task.run(bash: command, directory: projectDirectory.absolute().string)
//    }

    // generate plists
    //info("⚙️  Generating plists...")
    let fileWriter = FileWriter(project: project)
    //do {
        try fileWriter.writePlists()
//        if onlyPlists {
//            return
//        }
//    } catch {
//        throw GenerationError.writingError(error)
//    }

    // generate project
    //info("⚙️  Generating project...")
    let xcodeProject: XcodeProj
    //do {
        let projectGenerator = ProjectGenerator(project: project)

    let userName = ProcessInfo.processInfo.userName

        xcodeProject = try projectGenerator.generateXcodeProject(in: projectDirectory, userName: userName)
        
//    } catch {
//        throw GenerationError.generationError(error)
//    }

    // write project
    // info("⚙️  Writing project...")
    // do {
        try fileWriter.writeXcodeProject(xcodeProject, to: projectPath)

//        success("Created project at \(projectPath)")
//    } catch {
//        throw GenerationError.writingError(error)
//    }

    // write cache
//    if let cacheFile = cacheFile {
//        do {
//            try cacheFilePath.parent().mkpath()
//            try cacheFilePath.write(cacheFile.string)
//        } catch {
//            info("Failed to write cache: \(error.localizedDescription)")
//        }
//    }

    // run post gen command
//    if let command = project.options.postGenCommand {
//        try Task.run(bash: command, directory: projectDirectory.absolute().string)
//    }
    //try execute(specLoader: specLoader, projectSpecPath: projectSpecPath, project: project)
  }
  
  
}
struct ServerAction : ListAction {
  let shellProfile : ShellProfile
  let dependencies: [any Action]
  
  init(shellProfile: ShellProfile) {
    self.shellProfile = shellProfile
    self.dependencies = [
      XcodeGenAction(),
      Docker.Database(shellProfile: self.shellProfile)
    ]
  }
  

  func execute() async throws {
    guard let application = XcodeApp(filePath: "/Applications/Xcode-beta.app") else {
      throw InternalError.missingEnvironmentVariable("/Applications/Xcode-beta.app")
    }
    let swiftPackageURL = URL(filePath: "Bitness.xcodeproj")
    let workspace = try await application.openWorkspaceDocument(at: swiftPackageURL)
    try await workspace.debug(scheme: "bitnessd", runDestinationSpecifier: "platform:macOS, name:My Mac")
  }
}
