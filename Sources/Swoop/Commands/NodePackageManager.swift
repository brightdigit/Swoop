import Foundation
import ProcessExtensions
import ArgumentParser

enum NodePackageManager {
  
   struct Command: AsyncParsableCommand {
     static let configuration: CommandConfiguration = CommandConfiguration(
      commandName: "npm",
       subcommands: [Verify.self, Install.self, Run.self]
     )
   }
   
   struct Verify : AsyncParsableCommand {
     
   }
   
   struct Install : AsyncParsableCommand {
     func run() async throws {
       
       print("Running npm Install...")
       let command = """
         nvm use
         npm install
         """
       try await Process.run(
         with: Swoop.shellProfile.interperter,
         inProfile: Swoop.shellProfile.profilePath,
         command: command,
         currentDirectoryURL: URL(filePath: "Web")
       )
     }
   }
   
   struct Run : AsyncParsableCommand {
     @Argument var command: String = "dev"
    
     func run() async throws {
       print("Running npm run dev...")
       try createDirectoryIfNotExists(at: URL(filePath: ".swoop"))

       let outputFile = relativePath(
         from: URL(filePath: "Web"), to: URL(filePath: ".swoop/npm-run.log"))

       let command = """
         nvm use
         npm run dev > \(outputFile!) 2>&1 &
         echo $!
         """
       let output = try await Process.run(
        with: Swoop.shellProfile.interperter,
        inProfile: Swoop.shellProfile.profilePath,
         command: command,
         currentDirectoryURL: URL(filePath: "Web")
       )

       let pid = output.output.components(separatedBy: .newlines).compactMap {
         Int($0)
       }.last

       try pid?.description.write(toFile: ".swoop/npm-run.pid", atomically: true, encoding: .utf8)
     }
   }
}

extension NodePackageManager {
  struct RunInstall {
    let profile: ShellProfile

    init(profile: ShellProfile) {
      self.profile = profile
    }

    func execute() async throws {
      print("Running npm Install...")
      let command = """
        nvm use
        npm install
        """
      try await Process.run(
        with: profile.interperter,
        inProfile: profile.profilePath,
        command: command,
        currentDirectoryURL: URL(filePath: "Web")
      )
    }
  }

  struct RunCommand {
    let profile: ShellProfile

    func run() async throws {
      print("Running npm run dev...")
      try createDirectoryIfNotExists(at: URL(filePath: ".swoop"))

      let outputFile = relativePath(
        from: URL(filePath: "Web"), to: URL(filePath: ".swoop/npm-run.log"))

      let command = """
        nvm use
        npm run dev > \(outputFile!) 2>&1 &
        echo $!
        """
      let output = try await Process.run(
        with: profile.interperter,
        inProfile: profile.profilePath,
        command: command,
        currentDirectoryURL: URL(filePath: "Web")
      )

      let pid = output.output.components(separatedBy: .newlines).compactMap {
        Int($0)
      }.last

      try pid?.description.write(toFile: ".swoop/npm-run.pid", atomically: true, encoding: .utf8)
    }

  }
}
