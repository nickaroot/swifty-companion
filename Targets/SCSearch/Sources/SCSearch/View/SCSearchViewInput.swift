//
//  SCSearchViewInput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import SCUI

public protocol SCSearchViewInput: SCViewInputProtocol {
    var presenter: SCSearchComponent.ViewOutput! { get set }

    var navigationController: UINavigationController? { get }
    var tabBarController: UITabBarController? { get }

    var node: SCSearchComponent.MainNode! { get }

    var title: String? { get set }

    var statusBarStyle: UIStatusBarStyle { get set }

    var modalPresentationCapturesStatusBarAppearance: Bool { get set }

    var isNavigationBarShowing: Bool? { get set }

    var navigationBackButton: UIBarButtonItem? { get set }

    var navigationItem: UINavigationItem { get }

    var neverShowPlaceholders: Bool { get set }
}

extension SCSearchView: SCSearchViewInput {}
