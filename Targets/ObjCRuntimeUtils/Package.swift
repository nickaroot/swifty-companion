// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ObjCRuntimeUtils",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ObjCRuntimeUtils",
            targets: ["ObjCRuntimeUtils"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ObjCRuntimeUtils",
            dependencies: [],
            publicHeadersPath: "include"
        )
    ]
)
