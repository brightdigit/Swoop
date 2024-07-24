import Foundation
import ProcessExtensions

enum NodePackageManager {
  struct RunInstall : ListAction {
    let profile : ShellProfile
    let dependencies: [any Action]
    
    init(profile: ShellProfile) {
      self.profile = profile
      self.dependencies = [
        // NodeVersionManager.RunInstall(profile: profile)
      ]
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
  
  struct RunCommand : Action {
    let profile : ShellProfile
    
    func run() async throws {
      print("Running npm run dev...")
      try createDirectoryIfNotExists(at: URL(filePath: ".swoop"))
      
      let outputFile = relativePath(from: URL(filePath: "Web"), to: URL(filePath: ".swoop/npm-run.log"))
      
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

      let pid = output.output.components(separatedBy: .newlines).compactMap{
        Int($0)
      }.last
      
      try       pid?.description.write(toFile: ".swoop/npm-run.pid", atomically: true, encoding: .utf8)
    }
    
  }
}
