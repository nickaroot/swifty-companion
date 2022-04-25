//
//  ProjectsTableNode+DataSource.swift
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

extension ProjectsTableNode: ASCollectionDataSource {
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        nodeBlockForItemAt indexPath: IndexPath
    ) -> ASCellNodeBlock {
        { [weak self] in
            guard let self = self else { return ASCellNode() }

            guard
                let project = self.projectsDelegate.project(
                    modelAtIndex: indexPath.item
                )
            else { return ASCellNode() }

            let cellNode = Self.projectCellNode(
                project,
                isLast: indexPath.item == self.projectsDelegate.projectsCount() - 1
            )

            cellNode.style.flexBasis = .fraction(1)

            cellNode.actionNode.touchUpInsideBlock = { [weak self] _ in
                self?.projectsDelegate.didSelectProject(modelAtIndex: indexPath.item)
            }

            //            cellNode.modelHash = person.hashValue

            return cellNode
        }
    }

    func collectionNode(
        _ collectionNode: ASCollectionNode,
        numberOfItemsInSection section: Int
    ) -> Int {
        projectsDelegate.projectsCount()
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        1
    }
}
