//
//  RecentUsersTableHeaderCellNode.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 21.04.2022.
//

import AsyncDisplayKit
import SCUI
import TextureUI

class RecentUsersTableHeaderCellNode: SCCellNode {
    // MARK: - Title

    lazy var titleNode: SCTextNode = {
        let node = SCTextNode(typography: .headline3)

        node.text = "Recent"

        return node
    }()

    // MARK: - Layout Spec

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            VStack {
                titleNode
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
            }
        }
    }
}
