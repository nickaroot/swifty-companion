//
//  SearchUsersTableNode+DataSource.swift
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

extension SearchUsersTableNode: ASCollectionDataSource {
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        nodeBlockForItemAt indexPath: IndexPath
    ) -> ASCellNodeBlock {
        { [weak self] in
            guard let self = self else { return ASCellNode() }

            guard !self.isShimmering else {
                let cellNode = Self.personCellNode(.empty)

                cellNode.isShimmering = true

                return cellNode
            }

            guard
                let person = self.searchUsersDelegate.searchUser(
                    modelAtIndex: indexPath.item,
                    page: indexPath.section
                )
            else { return ASCellNode() }

            let cellNode = Self.personCellNode(person)

            //            cellNode.modelHash = person.hashValue

            return cellNode
        }
    }

    func collectionNode(
        _ collectionNode: ASCollectionNode,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard !isShimmering else { return 20 }

        guard let personsCount = searchUsersDelegate.searchUsersCount(atPage: section) else {
            return 0
        }

        return personsCount
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        guard !isShimmering else { return 1 }

        return searchUsersDelegate.searchUsersPages()
    }
}
