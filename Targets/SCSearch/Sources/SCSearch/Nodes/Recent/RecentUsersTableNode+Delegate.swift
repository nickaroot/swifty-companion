//
//  RecentUsersTableNode+Delegate.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCUI
import UIKit

extension RecentUsersTableNode: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)

        // MARK: - Header

        guard indexPath.item >= headersInSectionCount else { return }

        // MARK: - Cell

        let index = indexPath.item - headersInSectionCount

        recentUsersDelegate.didSelectRecentUser(
            atIndex: index,
            page: indexPath.section
        )
    }
}
