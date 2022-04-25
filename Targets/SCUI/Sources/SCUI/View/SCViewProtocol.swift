//
//  SCViewProtocol.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit

public protocol SCViewProtocol {
    associatedtype MainNode: SCMainNode

    var navigationController: UINavigationController? { get }
    var tabBarController: UITabBarController? { get }

    var navigationItem: UINavigationItem { get }

    var view: UIView! { get }

    var node: MainNode! { get }

    var title: String? { get set }

    var statusBarStyle: UIStatusBarStyle { get set }

    var isNavigationBarShowing: Bool? { get set }

    var navigationBackButton: UIBarButtonItem? { get set }

    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension SCViewProtocol {
    public var isNavigationBarShowing: Bool? {
        get {
            guard let isHidden = navigationController?.isNavigationBarHidden else { return nil }

            return !isHidden
        }

        nonmutating set {
            guard let showing = newValue else { return }

            navigationController?.setNavigationBarHidden(!showing, animated: true)
        }
    }

    public var navigationBackButton: UIBarButtonItem? {
        get { navigationItem.backBarButtonItem }

        nonmutating set { navigationItem.backBarButtonItem = newValue }
    }
}
