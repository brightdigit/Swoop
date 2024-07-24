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
    name: "Swoop",
    platforms: [.macOS(.v13)],
    dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
      .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3"),
      .package(url: "https://github.com/yonaskolb/Mint.git", from: "0.15.0"),
      .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.42.0"),
      //.package(url: "https://github.com/rensbreur/SwiftTUI", revision: "5371330"),
      .package(path: "Packages/DockerKit"),
      .package(path: "Packages/XcodePilot")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
    
        .executableTarget(
            name: "Swoop",
            dependencies: [
              "XcodePilot",              
              "Yams",
              .product(name: "ArgumentParser", package: "swift-argument-parser"),
              .product(name: "MintKit", package: "Mint"),
              .product(name: "ProjectSpec", package: "XcodeGen")
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
