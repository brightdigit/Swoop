// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
  SwiftSetting.enableExperimentalFeature("AccessLevelOnImport"),
  SwiftSetting.enableExperimentalFeature("BitwiseCopyable"),
  SwiftSetting.enableExperimentalFeature("GlobalActorIsolatedTypesUsability"),
  SwiftSetting.enableExperimentalFeature("IsolatedAny"),
  SwiftSetting.enableExperimentalFeature("MoveOnlyPartialConsumption"),
  SwiftSetting.enableExperimentalFeature("NestedProtocols"),
  SwiftSetting.enableExperimentalFeature("NoncopyableGenerics"),
  SwiftSetting.enableExperimentalFeature("RegionBasedIsolation"),
  SwiftSetting.enableExperimentalFeature("TransferringArgsAndResults"),
  SwiftSetting.enableExperimentalFeature("VariadicGenerics"),
  
  SwiftSetting.enableUpcomingFeature("FullTypedThrows"),
  SwiftSetting.enableUpcomingFeature("InternalImportsByDefault"),
  
  SwiftSetting.unsafeFlags([
    "-Xfrontend",
    "-warn-long-function-bodies=100"
  ]),
  SwiftSetting.unsafeFlags([
    "-Xfrontend",
    "-warn-long-expression-type-checking=100"
  ])
]

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
           ],
           swiftSettings: swiftSettings
       ),
      
    ]
)
