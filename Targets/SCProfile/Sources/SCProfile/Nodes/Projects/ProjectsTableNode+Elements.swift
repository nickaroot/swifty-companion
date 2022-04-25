//
//  ProjectsTableNode+Elements.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 07.03.2022.
//

import AsyncDisplayKit
import SCAPI
import SCAssets
import SCUI
import UIKit

extension ProjectsTableNode {
    class func projectCellNode(_ project: ProjectsUser, isLast: Bool) -> ProjectCellNode {
        let node = ProjectCellNode(project: project, isLast: isLast)

        node.backgroundColor = Asset.Colors.neutral0.color

        return node
    }
}
