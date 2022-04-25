//
//  SCRouterInputProtocol.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import UIKit

public protocol SCRouterInputProtocol {
    var navigationController: UINavigationController? { get set }
    var tabBarController: UITabBarController? { get set }
}

extension SCRouterInputProtocol {}
