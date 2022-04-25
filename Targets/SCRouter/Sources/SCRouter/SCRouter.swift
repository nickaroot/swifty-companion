//
//  SCRouter.swift
//  SCRouter
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import SCAPI
import SCProfile
import SCSearch
import SCUI

public class SCRouter: SCSearchRoutable, SCProfileRoutable {
    weak var component: SCRouterComponent!

    weak var navigation: ASNavigationController!

    weak var searchNavigation: ASNavigationController!

    public func revealProfile(user: BasicUser, sender: UIViewController?) {
        let profileComponent = component.profileComponent

        profileComponent.presenter.basicUser = user

        sender?.navigationController?.pushViewController(profileComponent.view, animated: true)
    }

    public func revealProfile(user: User, sender: UIViewController?) {
        let profileComponent = component.profileComponent

        profileComponent.presenter.user = user

        sender?.navigationController?.pushViewController(profileComponent.view, animated: true)
    }
}
