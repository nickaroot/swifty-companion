// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "UIKitRuntimeUtils",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "UIKitRuntimeUtils",
            targets: ["UIKitRuntimeUtils"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/nickaroot/Texture.git", .branch("spm")),
        .package(name: "ObjCRuntimeUtils", path: "../ObjCRuntimeUtils"),
    ],
    targets: [
        .target(
            name: "UIKitRuntimeUtils",
            dependencies: [
                .product(name: "AsyncDisplayKit", package: "Texture"),
                "ObjCRuntimeUtils",
            ],
            publicHeadersPath: "include",
            cSettings: [.headerSearchPath("include")]
        )
    ]

)
