// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SCProfile",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SCProfile",
            targets: ["SCProfile"]
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
    ],
    targets: [
        .target(
            name: "SCProfile",
            dependencies: [
                "NeedleFoundation",
                "TextureUI",
                "SCUI",
                "SCAPI",
            ]
        ),
        .testTarget(
            name: "SCProfileTests",
            dependencies: ["SCProfile"]
        ),
    ]
)
