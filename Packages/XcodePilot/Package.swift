// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodePilot",
    platforms: [.macOS(.v13)],
    products: [
   .library(
       name: "XcodePilot",
       targets: ["XcodePilot"])
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.

      .target(
          name: "XcodeScriptingBridge"
          
      ),
       
      .target(
          name: "XcodePilot",
          dependencies: ["XcodeScriptingBridge"]
      ),
    ]
)
