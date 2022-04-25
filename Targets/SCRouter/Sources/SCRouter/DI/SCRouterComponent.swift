//
//  SCRouterComponent.swift
//
//
//  Created by Nikita Arutyunov on 03.02.2022.
//

import AsyncDisplayKit
import NeedleFoundation
import SCAPI
import SCAssets
import SCHelpers
import SCProfile
import SCSearch
import SCUI

public final class SCRouterComponent: BootstrapComponent {

    // MARK: - API

    public var api: SCAPI {
        shared {
            SCAPI()
        }
    }

    // MARK: - Routable

    public var router: SCRouter {
        shared {
            let router = SCRouter()

            router.component = self

            router.navigation = navigation

            router.searchNavigation = searchNavigation

            return router
        }
    }

    public var searchRoutable: SCSearchRoutable {
        router
    }

    public var profileRoutable: SCProfileRoutable {
        router
    }

    // MARK: - Navigation

    public var navigation: ASNavigationController {
        shared {
            //            let navigation = ASNavigationController(rootViewController: tabBar)

            //            let navigation = ASNavigationController(rootViewController: authPhoneComponent.view)

            let navigation = ASNavigationController(rootViewController: tabBar)

            let navigationBarAppearance = UINavigationBarAppearance()

            navigationBarAppearance.backgroundColor = Asset.Colors.neutral0.color

            navigation.navigationBar.standardAppearance = navigationBarAppearance
            navigation.navigationBar.compactAppearance = navigationBarAppearance

            navigation.navigationBar.scrollEdgeAppearance = navigationBarAppearance

            if #available(iOS 15.0, *) {
                navigation.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
            }

            navigation.navigationBar.tintColor = Asset.Colors.neutral50.color

            navigation.isNavigationBarHidden = true
            navigation.modalPresentationCapturesStatusBarAppearance = false

            return navigation
        }
    }

    public var searchNavigation: ASNavigationController {
        shared {
            let navigation = ASNavigationController(rootViewController: searchComponent.view)

            let item = Item.search

            let navigationBarAppearance = UINavigationBarAppearance()

            navigationBarAppearance.backgroundColor = Asset.Colors.neutral0.color

            navigation.navigationBar.standardAppearance = navigationBarAppearance
            navigation.navigationBar.compactAppearance = navigationBarAppearance

            navigation.navigationBar.scrollEdgeAppearance = navigationBarAppearance

            if #available(iOS 15.0, *) {
                navigation.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
            }

            navigation.navigationBar.tintColor = Asset.Colors.neutral50.color

            navigation.title = item.title
            navigation.isNavigationBarHidden = true
            navigation.modalPresentationCapturesStatusBarAppearance = false

            navigation.tabBarItem = item.tabBarItem

            return navigation
        }
    }

    // MARK: - Tab Bar

    enum Item {
        case search

        var title: String {
            switch self {
            case .search:
                return "Желания"
            }
        }

        var image: UIImage {
            switch self {
            case .search:
                return UIImage(systemSymbol: .textMagnifyingglass)
            }
        }

        var tag: Int {
            switch self {
            case .search:
                return 1
            }
        }

        var tabBarItem: UITabBarItem {
            UITabBarItem(title: title, image: image, tag: tag)
        }
    }

    public var tabBar: ASTabBarController {
        shared {
            let tabBar = ASTabBarController()

            tabBar.modalPresentationCapturesStatusBarAppearance = false

            let tabBarAppearance = UITabBarAppearance()

            tabBarAppearance.backgroundColor = Asset.Colors.neutral0.color

            tabBar.tabBar.standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                tabBar.tabBar.scrollEdgeAppearance = tabBarAppearance
            }

            tabBar.tabBar.isTranslucent = false
            tabBar.tabBar.unselectedItemTintColor = Asset.Colors.neutral40.color
            tabBar.tabBar.tintColor = Asset.Colors.neutral50.color

            tabBar.setViewControllers(
                [
                    searchNavigation
                ],
                animated: false
            )

            return tabBar
        }
    }

    // MARK: - Search

    public var searchComponent: SCSearchComponent {
        SCSearchComponent(parent: self)
    }

    // MARK: - Profile

    public var profileComponent: SCProfileComponent {
        SCProfileComponent(parent: self)
    }

    // MARK: - Custom Navigation

    public func customNavigation(rootViewController: UIViewController) -> ASNavigationController {
        let navigation = ASNavigationController(rootViewController: rootViewController)

        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.backgroundColor = Asset.Colors.neutral0.color

        navigation.navigationBar.standardAppearance = navigationBarAppearance
        navigation.navigationBar.compactAppearance = navigationBarAppearance

        navigation.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        if #available(iOS 15.0, *) {
            navigation.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
        }

        navigation.navigationBar.tintColor = Asset.Colors.neutral50.color

        navigation.navigationBar.titleTextAttributes =
            SCTypography.headline3.scTextAttributes.attributes

        navigation.isNavigationBarHidden = true
        navigation.modalPresentationCapturesStatusBarAppearance = false

        return navigation
    }
}
