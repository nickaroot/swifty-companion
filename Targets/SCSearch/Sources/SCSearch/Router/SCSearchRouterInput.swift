//
//  SCSearchRouterInput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCAPI
import SCUI
import UIKit

protocol SCSearchRouterInput: SCRouterInputProtocol {
    var navigationController: UINavigationController? { get set }
    var tabBarController: UITabBarController? { get set }

    func revealProfile(user: BasicUser, sender: UIViewController?)

    func revealProfile(user: User, sender: UIViewController?)
}

extension SCSearchRouter: SCSearchRouterInput {
    func revealProfile(user: BasicUser, sender: UIViewController?) {
        routable.revealProfile(user: user, sender: sender)
    }

    func revealProfile(user: User, sender: UIViewController?) {
        routable.revealProfile(user: user, sender: sender)
    }
}
