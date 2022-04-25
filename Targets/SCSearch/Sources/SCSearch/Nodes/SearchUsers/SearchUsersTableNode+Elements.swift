//
//  SearchUsersTableNode+Elements.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCAPI
import SCUI
import UIKit

extension SearchUsersTableNode {
    class func personCellNode(_ user: BasicUser) -> BasicUserCellNode {
        let node = BasicUserCellNode(user: user)

        node.style.flexBasis = .fraction(1)

        return node
    }
}
