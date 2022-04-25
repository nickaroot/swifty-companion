//
//  SCSearchPresenter+SCSearchDelegate.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCAPI
import SCUI
import UIKit

public protocol SCSearchDelegate: AnyObject {
    var layoutState: LayoutState { get set }

    var me: User? { get }

    func updateLayoutState()

    func auth()

    func search(_ query: String?)

    func didTapProfile()
}

extension SCSearchPresenter: SCSearchDelegate {
    var isSearchUsersShimmering: Bool {
        get {
            view.node.searchUsersTableNode.isShimmering
        }

        set(isShimmering) {
            view.node.searchUsersTableNode.isShimmering = isShimmering
        }
    }

    public func auth() {
        Task { [weak self] in
            guard let code = try? await interactor.authCode else { return }

            guard let token = try? await interactor.authToken(forCode: code) else { return }

            updateLayoutState()

            updateMe()
        }
    }

    public func search(_ query: String?) {
        guard let query = query, !query.isBlank else {
            users = []

            return updateLayoutState()
        }

        isSearchUsersShimmering = true

        updateLayoutState()

        searchTask = Task { [weak self] in
            let users = try? await interactor.users(query)

            self?.users = users ?? []
        }
    }

    public func didTapProfile() {
        guard let user = me else { return }

        router.revealProfile(user: user, sender: view as? UIViewController)
    }
}
