//
//  SCViewInputProtocol.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

public protocol SCViewInputProtocol: AnyObject {
    associatedtype MainNode: SCMainNode

    var navigationController: UINavigationController? { get }
    var tabBarController: UITabBarController? { get }

    var node: MainNode! { get }

    var title: String? { get set }

    var statusBarStyle: UIStatusBarStyle { get set }

    var isNavigationBarShowing: Bool? { get set }

    var navigationBackButton: UIBarButtonItem? { get set }

    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}
