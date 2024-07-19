// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DockerKit",
    platforms: [.macOS(.v13)],
    products: [
    
      .library(name: "DockerKit", targets: ["DockerKit"]),
      
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
      .target(
           name: "DockerOpenAPIClient",
           dependencies: ["DockerOpenAPITypes"]
      ),
       .target(
           name: "DockerKit",
           dependencies: ["DockerOpenAPIClient"]
       ),
      
       .target(
           name: "DockerOpenAPITypes",
           dependencies: [
            .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
           ]
       ),
      
    ]
)