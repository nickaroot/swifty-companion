// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SCRouter",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SCRouter",
            targets: ["SCRouter"]
        )
    ],
    dependencies: [
        .package(
            name: "NeedleFoundation",
            url: "https://github.com/uber/needle",
            branch: "master"
        ),
        .package(url: "https://github.com/nickaroot/TextureUI.git", branch: "master"),
        .package(name: "SCUI", path: "../SCUI"),
        .package(name: "SCAPI", path: "../SCAPI"),
        .package(name: "SCAssets", path: "../SCAssets"),
        .package(name: "SCHelpers", path: "../SCHelpers"),
        .package(name: "SCSearch", path: "../SCSearch"),
        .package(name: "SCProfile", path: "../SCProfile"),
    ],
    targets: [
        .target(
            name: "SCRouter",
            dependencies: [
                "NeedleFoundation",
                "TextureUI",
                "SCUI",
                "SCAPI",
                "SCAssets",
                "SCHelpers",
                "SCSearch",
                "SCProfile",
            ]
        ),
        .testTarget(
            name: "SCRouterTests",
            dependencies: ["SCRouter"]
        ),
    ]
)
