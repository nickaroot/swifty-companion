//
//  RecentUsersTableNode+DataSource.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCAPI
import SCAssets
import SCUI
import TextureUI
import UIKit

extension RecentUsersTableNode: ASCollectionDataSource {
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        nodeBlockForItemAt indexPath: IndexPath
    ) -> ASCellNodeBlock {
        { [weak self] in
            guard let self = self else { return ASCellNode() }

            // MARK: - Header

            guard indexPath.item >= self.headersInSectionCount else {
                return RecentUsersTableHeaderCellNode()
            }

            // MARK: - Cell

            let index = indexPath.item - self.headersInSectionCount

            guard
                let user = self.recentUsersDelegate.recentUser(
                    modelAtIndex: index,
                    page: indexPath.section
                )
            else { return ASCellNode() }

            let action: SCActionNode = {
                let node = SCButtonNode(buttonStyle: .none)

                node.style.preferredLayoutSize = ASLayoutSize(width: 32, height: 32)

                node.tintColor = Asset.Colors.neutral50.color

                node.systemSymbol = (
                    .xmark, UIImage.SymbolConfiguration(pointSize: 11, weight: .bold)
                )

                node.imageContentMode = .center

                node.touchUpInsideBlock = { [weak self] _ in
                    self?.recentUsersDelegate
                        .didRemoveRecentUser(atIndex: index, page: indexPath.item)
                }

                return node
            }()

            let cellNode = Self.personCellNode(user, action)

            cellNode.style.flexBasis = .fraction(1)

            //            cellNode.modelHash = user.hashValue

            return cellNode
        }
    }

    func collectionNode(
        _ collectionNode: ASCollectionNode,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard
            let personsCount = recentUsersDelegate.recentUsersCount(atPage: section),
            personsCount > 0
        else {
            return 0
        }

        return headersInSectionCount + personsCount
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        recentUsersDelegate.recentUsersPages()
    }
}
