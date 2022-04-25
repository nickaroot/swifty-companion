//
//  Dependencies.swift
//  tuistManifests
//
//  Created by Nikita Arutyunov on 07.02.2022.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.5.0")),
        .remote(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", requirement: .upToNextMajor(from: "2.1.3")),
        .remote(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", requirement: .upToNextMajor(from: "9.0.6")),
        .remote(url: "https://github.com/marmelroy/PhoneNumberKit.git", requirement: .upToNextMajor(from: "3.3.4")),
        .remote(url: "https://github.com/nickaroot/TextureUI.git", requirement: .branch("master")),
        .local(path: "Targets/SCAPI"),
        .local(path: "Targets/SCAssets"),
        .local(path: "Targets/SCHelpers"),
        .local(path: "Targets/SCUI"),
        .local(path: "Targets/SCRouter"),
        .local(path: "Targets/SCSearch"),
        .local(path: "Targets/SCProfile"),
    ],
    platforms: [.iOS]
)
