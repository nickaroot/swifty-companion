//
//  SearchUsersTableNode+Delegate.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCUI
import UIKit

extension SearchUsersTableNode: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)

        searchUsersDelegate.didSelectSearchUser(
            atIndex: indexPath.item,
            page: indexPath.section
        )
    }
}
