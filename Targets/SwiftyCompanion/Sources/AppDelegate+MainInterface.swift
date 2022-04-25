//
//  AppDelegate+MainInterface.swift
//  SwiftyCompanion
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import SCRouter
import UIKit

extension AppDelegate {
    func configureMainInterface() {
        //        ASDisplayNode.shouldShowRangeDebugOverlay = true
        //        ASControlNode.enableHitTestDebug = true
        //        ASImageNode.shouldShowImageScalingOverlay = true

        ASDisableLogging()

        window = UIWindow()
        window?.backgroundColor = .black
        window?.rootViewController = SCRouterComponent().navigation
        window?.makeKeyAndVisible()
    }
}
