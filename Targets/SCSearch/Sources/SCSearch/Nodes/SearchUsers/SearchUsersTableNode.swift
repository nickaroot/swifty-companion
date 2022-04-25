//
//  SearchUsersTableNode.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCAPI
import SCUI
import UIKit

class SearchUsersTableNode: SCCollectionNode {
    weak var searchUsersDelegate: SearchUsersDelegate!

    // MARK: - Layout Did Finish

    override func layoutDidFinish() {
        super.layoutDidFinish()

        guard isShimmering else { return }

        for section in 0..<numberOfSections {
            for item in 0..<numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)

                guard let cellNode = nodeForItem(at: indexPath) as? SCCellNode else {
                    continue
                }

                guard cellNode.isShimmering else { return }

                cellNode.shimmerUpdate()
            }
        }
    }
}
