// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SCAPI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SCAPI",
            targets: ["SCAPI"]
        )
    ],
    dependencies: [
        .package(
            name: "NeedleFoundation",
            url: "https://github.com/uber/needle",
            branch: "master"
        ),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
        .package(name: "SCHelpers", path: "../SCHelpers"),
    ],
    targets: [
        .target(
            name: "SCAPI",
            dependencies: [
                "NeedleFoundation",
                "Alamofire",
                "SCHelpers",
            ]
        ),
        .testTarget(
            name: "SCAPITests",
            dependencies: ["SCAPI"]
        ),
    ]
)
