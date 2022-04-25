// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SCAssets",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SCAssets",
            targets: ["SCAssets"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftGen/SwiftGen.git", branch: "stable")
    ],
    targets: [
        .target(
            name: "SCAssets",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SCAssetsTests",
            dependencies: ["SCAssets"]
        ),
    ]
)
