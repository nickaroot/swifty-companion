//
//  SCSearchPresenter+SearchUsersDelegate.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 12.04.2022.
//

import SCAPI
import SCUI
import UIKit

public protocol SearchUsersDelegate: AnyObject {
    func searchUser(modelAtIndex index: Int, page: Int) -> BasicUser?

    func searchUsersCount(atPage page: Int) -> Int?

    func searchUsersPages() -> Int

    func didSelectSearchUser(atIndex index: Int, page: Int)
}

extension SCSearchPresenter: SearchUsersDelegate {
    public func searchUser(modelAtIndex index: Int, page: Int) -> BasicUser? {
        guard index >= 0, index < users.count else { return nil }

        return users[index]
    }

    public func searchUsersCount(atPage page: Int) -> Int? {
        users.count
    }

    public func searchUsersPages() -> Int {
        1
    }

    public func didSelectSearchUser(atIndex index: Int, page: Int) {
        guard let user = searchUser(modelAtIndex: index, page: page) else { return }

        recentUsers.removeAll(where: { $0.id == user.id })

        recentUsers.append(user)

        router.revealProfile(user: user, sender: view as? UIViewController)
    }
}
