// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swoop",
    platforms: [.macOS(.v13)],
    products: [
    
      .library(name: "DockerKit", targets: ["DockerKit"]),
      
   .library(
       name: "XcodeCopilot",
       targets: ["XcodeCopilot"])
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
      .package(url: "https://github.com/rensbreur/SwiftTUI", revision: "5371330")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
      .target(
           name: "DockerOpenAPIClient",
           dependencies: ["DockerOpenAPITypes"]),
       .target(
           name: "DockerKit",
           dependencies: ["DockerOpenAPIClient"]),
       .target(
           name: "DockerOpenAPITypes",
           dependencies: [
            .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
           ]),
      .target(
          name: "XcodeCopilot",
          dependencies: []),
        .executableTarget(
            name: "Swoop",
            dependencies: ["SwiftTUI", "XcodeCopilot"]
        ),
    ]
)
