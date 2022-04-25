//
//  ProjectsTableNode+Delegate.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCUI
import UIKit

extension ProjectsTableNode: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        deselectItem(at: indexPath, animated: true)
    }
}
