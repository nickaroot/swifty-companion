// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SCUI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SCUI",
            targets: ["SCUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ra1028/DifferenceKit.git", from: "1.2.0"),
        .package(
            url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git",
            .upToNextMajor(from: "2.1.3")
        ),
        .package(
            url: "https://github.com/SwiftKickMobile/SwiftMessages.git",
            .upToNextMajor(from: "9.0.6")
        ),
        .package(url: "https://github.com/nickaroot/TextureUI.git", branch: "master"),
        .package(name: "SCHelpers", path: "../SCHelpers"),
        .package(name: "SCAssets", path: "../SCAssets"),
    ],
    targets: [
        .target(
            name: "SCUI",
            dependencies: [
                "DifferenceKit",
                "SFSafeSymbols",
                "SwiftMessages",
                "TextureUI",
                "SCHelpers",
                "SCAssets",
            ]
        ),
        .testTarget(
            name: "SCUITests",
            dependencies: ["SCUI"]
        ),
    ]
)
