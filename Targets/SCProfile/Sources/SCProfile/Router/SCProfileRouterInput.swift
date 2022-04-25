//
//  SCProfileRouterInput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCUI
import UIKit

protocol SCProfileRouterInput: SCRouterInputProtocol {
    var navigationController: UINavigationController? { get set }
    var tabBarController: UITabBarController? { get set }
}

extension SCProfileRouter: SCProfileRouterInput {}
