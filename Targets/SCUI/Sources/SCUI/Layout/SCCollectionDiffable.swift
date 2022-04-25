//
//  SCCollectionDiffable.swift
//
//
//  Created by Nikita Arutyunov on 03.01.2022.
//

import DifferenceKit

extension Int: ContentIdentifiable, ContentEquatable {}

public protocol SCCollectionDiffable: AnyObject {
    func modelsHashes(in collectionNode: SCCollectionNode) -> [ArraySection<Int, Int>]?
}
