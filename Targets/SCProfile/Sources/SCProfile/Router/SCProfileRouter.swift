//
//  SCProfileRouter.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCUI
import UIKit

public final class SCProfileRouter: SCRouterProtocol {
    public weak var navigationController: UINavigationController?
    public weak var tabBarController: UITabBarController?

    weak var routable: SCProfileRoutable!

    init(
        routable: SCProfileRoutable
    ) {
        self.routable = routable
    }
}
