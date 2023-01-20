// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SCHelpers",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SCHelpers",
            targets: ["SCHelpers"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/nickaroot/TextureUI.git", branch: "main"),
        .package(name: "UIKitRuntimeUtils", path: "../UIKitRuntimeUtils"),
        .package(name: "SCAssets", path: "../SCAssets"),
    ],
    targets: [
        .target(
            name: "SCHelpers",
            dependencies: [
                "Alamofire",
                "TextureUI",
                "UIKitRuntimeUtils",
                "SCAssets",
            ]
        ),
        .testTarget(
            name: "SCHelpersTests",
            dependencies: ["SCHelpers"],
            path: "Tests"
        ),
    ]
)
