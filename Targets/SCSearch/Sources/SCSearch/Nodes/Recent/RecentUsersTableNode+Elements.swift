//
//  RecentUsersTableNode+Elements.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCAPI
import SCUI
import UIKit

extension RecentUsersTableNode {
    class func personCellNode(_ user: BasicUser, _ action: SCActionNode) -> BasicUserCellNode {
        let node = BasicUserCellNode(user: user, action: action)

        return node
    }
}
