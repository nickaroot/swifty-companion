//
//  SCSearchPresenter.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import AuthenticationServices
import SCAPI
import SCAssets
import SCUI

public enum LayoutState {
    case auth, initial, recent, search, empty
}

public final class SCSearchPresenter<ViewInput: SCSearchComponent.ViewInput>: NSObject,
    SCPresenterProtocol,
    SCKeyboardDelegate, ASWebAuthenticationPresentationContextProviding
{
    typealias Component = SCSearchComponent

    public var me: User? {
        didSet {
            if let meDisplayName = me?.displayName {
                view.node.initialTitleNode.text = """
                    Hi, \(meDisplayName)!
                    """
            } else {
                view.node.initialTitleNode.text = """
                    You're awesome!
                    """
            }

            view.node.initialProfileNode.isLoading = false

            ASPerformBlockOnMainThread { [weak self] in
                self?.view.node.searchUsersTableNode
                    .reloadData {
                        self?.updateLayoutState()
                    }
            }
        }
    }

    var users = [BasicUser]() {
        didSet {
            ASPerformBlockOnMainThread { [weak self] in
                self?.isSearchUsersShimmering = false

                self?.updateLayoutState()
                self?.view.node.searchUsersTableNode.reloadData()
            }
        }
    }

    var recentUsers = [BasicUser]() {
        didSet {
            ASPerformBlockOnMainThread { [weak self] in
                self?.view.node.recentUsersTableNode
                    .reloadData {
                        self?.updateLayoutState()
                    }
            }
        }
    }

    // MARK: - Layout State

    public var layoutState = LayoutState.initial {
        didSet {
            guard layoutState != oldValue else { return }

            ASPerformBlockOnMainThread { [weak self] in
                if self?.layoutState != .auth {
                    if self?.view.node.authIconNode.supernode != nil {
                        self?.view.node.authIconNode.removeFromSupernode()
                    }

                    if self?.view.node.authTitleNode.supernode != nil {
                        self?.view.node.authTitleNode.removeFromSupernode()
                    }

                    if self?.view.node.authSubtitleNode.supernode != nil {
                        self?.view.node.authSubtitleNode.removeFromSupernode()
                    }

                    if self?.view.node.authButtonNode.supernode != nil {
                        self?.view.node.authButtonNode.removeFromSupernode()
                    }
                }

                if self?.layoutState != .initial {
                    if self?.view.node.initialIconNode.supernode != nil {
                        self?.view.node.initialIconNode.removeFromSupernode()
                    }

                    if self?.view.node.initialTitleNode.supernode != nil {
                        self?.view.node.initialTitleNode.removeFromSupernode()
                    }

                    if self?.view.node.initialSubtitleNode.supernode != nil {
                        self?.view.node.initialSubtitleNode.removeFromSupernode()
                    }

                    if self?.view.node.initialSearchNode.supernode != nil {
                        self?.view.node.initialSearchNode.removeFromSupernode()
                    }

                    if self?.view.node.initialProfileNode.supernode != nil {
                        self?.view.node.initialProfileNode.removeFromSupernode()
                    }
                }

                if self?.layoutState != .recent {
                    if self?.view.node.recentUsersTableNode.supernode != nil {
                        self?.view.node.recentUsersTableNode.removeFromSupernode()
                    }
                }

                if self?.layoutState != .search {
                    if self?.view.node.searchUsersTableNode.supernode != nil {
                        self?.view.node.searchUsersTableNode.removeFromSupernode()
                    }
                }

                if self?.layoutState != .empty {
                    if self?.view.node.emptyIconNode.supernode != nil {
                        self?.view.node.emptyIconNode.removeFromSupernode()
                    }

                    if self?.view.node.emptyTitleNode.supernode != nil {
                        self?.view.node.emptyTitleNode.removeFromSupernode()
                    }

                    if self?.view.node.emptySubtitleNode.supernode != nil {
                        self?.view.node.emptySubtitleNode.removeFromSupernode()
                    }

                    if self?.view.node.emptyButtonNode.supernode != nil {
                        self?.view.node.emptyButtonNode.removeFromSupernode()
                    }
                }

                self?.view.node.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
            }
        }
    }

    public func updateLayoutState() {
        ASPerformBlockOnMainThread { [unowned self] in
            guard interactor.isAuthorized else {
                return layoutState = .auth
            }

            let searchBarIsFirstResponder = view.node.searchBarNode.view.isFirstResponder
            let searchQueryIsBlank = searchQuery?.isBlank ?? true
            let hasSearchResults = searchUsersPages() > 0 && (searchUsersCount(atPage: 0) ?? 0) > 0

            if !searchBarIsFirstResponder, searchQueryIsBlank {
                return layoutState = .initial
            } else if searchBarIsFirstResponder, searchQueryIsBlank {
                return layoutState = .recent
            } else if hasSearchResults || isSearchUsersShimmering {
                return layoutState = .search
            } else if searchBarIsFirstResponder, !hasSearchResults {
                return layoutState = .empty
            }

            if searchBarIsFirstResponder && searchQueryIsBlank
                || hasSearchResults || isSearchUsersShimmering
            {
                return layoutState = .search
            } else {
                return layoutState = .empty
            }
        }
    }

    // MARK: - Search

    var searchTask: Task<(), Never>? {
        willSet {
            searchTask?.cancel()
        }
    }

    var searchQuery: String? {
        (view.node.searchBarNode.view as? UISearchBar)?.text
    }

    public weak var view: ViewInput!

    var router: Component.RouterInput!
    var interactor: Component.InteractorInput!

    public var keyboardObserver: (NSObjectProtocol, NSObjectProtocol)?

    public func configureView() {
        updateLayoutState()

        updateMe()
    }

    public func showView() {
        router.navigationController = view.navigationController
        router.tabBarController = view.tabBarController

        setupNavigationBar()

        keyboardSubscribe()
    }

    public func hideView() {
        keyboardUnsubscribe()
    }

    func setupNavigationBar() {
        view.title = "Search"
        view.statusBarStyle = .default
        view.modalPresentationCapturesStatusBarAppearance = true
        view.isNavigationBarShowing = true
        view.navigationBackButton = UIBarButtonItem()

        do {
            let appearance = UINavigationBarAppearance()

            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = Asset.Colors.neutral0.color

            view.navigationItem.standardAppearance = appearance
            view.navigationItem.scrollEdgeAppearance = appearance
        }
    }

    func updateMe() {
        Task { [weak self] in
            guard let me = try? await self?.interactor.me() else {
                self?.updateLayoutState()

                return
            }

            self?.me = me
        }
    }

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor
    {
        guard let window = view.node.view.window ?? UIApplication.shared.keyWindow else {
            fatalError()
        }

        return window
    }
}
