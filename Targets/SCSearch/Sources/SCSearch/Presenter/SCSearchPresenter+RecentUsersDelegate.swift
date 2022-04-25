//
//  SCSearchPresenter+RecentUsersDelegate.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 21.04.2022.
//

import SCAPI
import SCUI
import UIKit

public protocol RecentUsersDelegate: AnyObject {
    func recentUser(modelAtIndex index: Int, page: Int) -> BasicUser?

    func recentUsersCount(atPage page: Int) -> Int?

    func recentUsersPages() -> Int

    func didSelectRecentUser(atIndex index: Int, page: Int)

    func didRemoveRecentUser(atIndex index: Int, page: Int)
}

extension SCSearchPresenter: RecentUsersDelegate {
    public func recentUser(modelAtIndex index: Int, page: Int) -> BasicUser? {
        guard index >= 0, index < recentUsers.count else { return nil }

        return recentUsers[index]
    }

    public func recentUsersCount(atPage page: Int) -> Int? {
        recentUsers.count
    }

    public func recentUsersPages() -> Int {
        1
    }

    public func didSelectRecentUser(atIndex index: Int, page: Int) {
        guard let user = recentUser(modelAtIndex: index, page: page) else { return }

        router.revealProfile(user: user, sender: view as? UIViewController)
    }

    public func didRemoveRecentUser(atIndex index: Int, page: Int) {
        guard index >= 0, index < recentUsers.count else { return }

        recentUsers.remove(at: index)
    }
}
