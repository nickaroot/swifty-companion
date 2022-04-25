//
//  SCSegmentDelegate.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import Foundation

public protocol SCSegmentDelegate: AnyObject {
    func segmentNode(_ segmentNode: SCSegmentNode, selectedIndexDidChanged selectedIndex: Int)
}
