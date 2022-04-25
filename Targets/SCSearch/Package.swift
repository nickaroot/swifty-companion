// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SCSearch",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SCSearch",
            targets: ["SCSearch"]
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
            name: "SCSearch",
            dependencies: [
                "NeedleFoundation",
                "TextureUI",
                "SCUI",
                "SCAPI",
            ]
        ),
        .testTarget(
            name: "SCSearchTests",
            dependencies: ["SCSearch"]
        ),
    ]
)
