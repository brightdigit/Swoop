// The Swift Programming Language
// https://docs.swift.org/swift-book
import ScriptingBridge

let appURL = URL(filePath: "/Applications/Xcode-beta.app")
guard let application = SBApplication(url: appURL) else {
  exit(1)
}

let xcode = application as XcodeApplication
let projectPath = "/Users/leo/Documents/Projects/Bitness/Bitness.xcodeproj"
let projectURL = URL(filePath: projectPath)
let openResult = xcode.open?(projectPath)

guard let elements = xcode.documents?.get() else {
  exit(1)
}

let document = xcode.documents?.object(withName: projectURL.lastPathComponent)  as? XcodeWorkspaceDocument

//guard let bitnessdScheme = document?.schemes?.object(withName: "bitnessd") as? XcodeScheme else {
//  exit(1)
//}
guard let document = document else {
  exit(1)
}
guard let runDestinations = document.runDestinations else {
  exit(1)
}
for runDestination in runDestinations {
  guard let destination = runDestination as? XcodeRunDestination else {
    exit(1)
  }
  print(destination.name)
  dump(destination)
}


let result = document.debugScheme?("bitnessd", runDestinationSpecifier: "platform:macOS, arch:arm64e, id:00008112-00124531223BC01E, name:My Mac", skipBuilding: true, commandLineArguments: [], environmentVariables: [])
/
