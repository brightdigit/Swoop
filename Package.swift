// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swoop",
    platforms: [.macOS(.v13)],
    dependencies: [
      .package(url: "https://github.com/rensbreur/SwiftTUI", revision: "5371330")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Swoop",
            dependencies: ["SwiftTUI"]
        ),
    ]
)
