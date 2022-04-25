//
//  SCSearchRouter.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCUI
import UIKit

public final class SCSearchRouter: SCRouterProtocol {
    public weak var navigationController: UINavigationController?
    public weak var tabBarController: UITabBarController?

    weak var routable: SCSearchRoutable!

    init(
        routable: SCSearchRoutable
    ) {
        self.routable = routable
    }
}
