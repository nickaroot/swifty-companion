//
//  ProjectsTableNode+FlowLayout.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCUI
import UIKit

extension ProjectsTableNode: ASCollectionDelegateFlowLayout {
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        willBeginBatchFetchWith context: ASBatchContext
    ) {
        context.completeBatchFetching(true)
    }
}
