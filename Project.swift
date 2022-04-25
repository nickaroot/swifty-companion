import ProjectDescription

// MARK: - Project

let name = "SwiftyCompanion"

let organizationName = "Nikita Arutyunov"

let project = Project(
    name: name,
    organizationName: organizationName,
    settings: .settings(
        base: [
            "OTHER_LDFLAGS": "-ObjC -all_load",
        ],
        configurations: [
            Configuration.debug(
                name: "Debug",
                settings: SettingsDictionary()
                    .currentProjectVersion("1")
                    .marketingVersion("1.0")
                    .automaticCodeSigning(devTeam: "D4LJ38764L"),
                xcconfig: .relativeToRoot("Configs/Debug.xcconfig")
            ),
            
            Configuration.release(
                name: "Release",
                settings: SettingsDictionary()
                    .currentProjectVersion("1")
                    .marketingVersion("1.0")
                    .automaticCodeSigning(devTeam: "D4LJ38764L"),
                xcconfig: .relativeToRoot("Configs/Release.xcconfig")
            )
        ],
        defaultSettings: .essential
    ),
    targets: [
        Target(
            name: "Swifty Companion",
            platform: .iOS,
            product: .app,
            productName: "Swifty Companion",
            bundleId: "com.freezone.swifty-companion",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .file(path: .relativeToRoot("Configs/Info.plist")),
            sources: "Targets/SwiftyCompanion/Sources/**",
            resources: "Targets/SwiftyCompanion/Resources/**",
            entitlements: .relativeToRoot("Configs/Swifty Companion.entitlements"),
            scripts: [
                .pre(
                    tool: "swift",
                    arguments: "format", "-ipr", "Targets",
                    name: "Swift Format"
                ),
                .pre(
                    tool: "Tuist/Dependencies/SwiftPackageManager/.build/checkouts/needle/Generator/bin/needle",
                    arguments: "generate", "Targets/SwiftyCompanion/Sources/NeedleGenerated.swift", "Targets/", #"--additional-imports "import SCRouter""#,
                     name: "Needle Generator",
                     runForInstallBuildsOnly: true
                ),
                .pre(
                    tool: "swiftgen",
                    arguments: "config", "run", "--config", "Targets/SCAssets/swiftgen.yml",
                    name: "SwiftGen",
                    runForInstallBuildsOnly: true
                ),
            ],
            dependencies: [
                .sdk(name: "c++", type: .library),
                .external(name: "Alamofire"),
                .external(name: "SwiftMessages"),
                .external(name: "PhoneNumberKit"),
                .external(name: "TextureUI"),
                .external(name: "SCUI"),
                .external(name: "SCAssets"),
                .external(name: "SCHelpers"),
                .external(name: "SCAPI"),
                .external(name: "SCRouter"),
                .external(name: "SCSearch"),
                .external(name: "SCProfile"),
            ]
        ),
    ],
    schemes: [],
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: .default
)
