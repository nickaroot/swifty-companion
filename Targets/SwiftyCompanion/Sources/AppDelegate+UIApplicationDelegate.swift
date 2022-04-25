//
//  AppDelegate+UIApplicationDelegate.swift
//  SwiftyCompanion
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import SCAPI
import UIKit

extension AppDelegate: UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerProviderFactories()

        //        Task {
        //            if case .success(let testData) = try? await SCAPI().getTestData() { print(testData) }
        //        }

        configureMainInterface()

        return true
    }

    //    func applicationWillEnterForeground(_ application: UIApplication) {
    //        NotificationCenter.default.post(name: .willEnterForeground, object: nil)
    //    }
    //
    //    func applicationDidEnterBackground(_ application: UIApplication) {
    //        NotificationCenter.default.post(name: .didEnterBackground, object: nil)
    //    }
    //
    //    func applicationDidBecomeActive(_ application: UIApplication) {
    //        NotificationCenter.default.post(name: .didBecomeActive, object: nil)
    //    }
    //
    //    func applicationWillResignActive(_ application: UIApplication) {
    //        NotificationCenter.default.post(name: .willResignActive, object: nil)
    //    }
}
