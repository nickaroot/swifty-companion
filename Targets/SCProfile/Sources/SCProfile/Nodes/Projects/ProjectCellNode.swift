//
//  SearchUsersPersonCellNode.swift
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

class ProjectCellNode: SCCellNode {

    let project: ProjectsUser

    let isLast: Bool

    // MARK: - Title

    lazy var titleNode: SCTextNode = {
        let node = SCTextNode()

        node.tintColor = Asset.Colors.neutral50.color

        node.text = project.project?.name.trimmingBlank ?? "—"

        return node
    }()

    // MARK: - Date Started

    lazy var dateStartedNode: SCTextNode = {
        let node = SCTextNode(typography: .caption2)

        node.tintColor = Asset.Colors.neutral40.color

        node.text = project.createdAt?.description

        return node
    }()

    // MARK: - Mark

    lazy var markNode: SCTextNode = {
        let node = SCTextNode()

        node.tintColor =
            (project.isValidated ?? false) ? Asset.Colors.green50.color : Asset.Colors.red50.color

        if let mark = project.finalMark {
            node.text = mark.description
        }

        return node
    }()

    lazy var inProgressNode: SCImageNode = {
        let node = SCImageNode()

        node.tintColor = Asset.Colors.neutral30.color

        node.image = UIImage(
            systemSymbol: .clock,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        )
        .withRenderingMode(.alwaysTemplate)

        node.contentMode = .center

        return node
    }()

    // MARK: - Chevron

    lazy var chevronNode: SCImageNode = {
        let node = SCImageNode()

        node.tintColor = Asset.Colors.neutral40.color

        node.image = UIImage(
            systemSymbol: .chevronRight,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        )
        .withRenderingMode(.alwaysTemplate)

        node.contentMode = .center

        return node
    }()

    // MARK: - Separator

    lazy var separatorNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(width: .fraction(1), height: 1)

        node.backgroundColor = Asset.Colors.neutral20.color

        return node
    }()

    // MARK: - Action

    lazy var actionNode: SCActionNode = {
        let node = SCActionNode()

        node.normalBackgroundColor = backgroundColor

        node.layoutSpecBlock = { [unowned self] _, _ in actionLayoutSpec }

        return node
    }()

    // MARK: - Init

    init(
        project: ProjectsUser,
        isLast: Bool
    ) {
        self.project = project
        self.isLast = isLast
    }

    // MARK: - Layout Spec

    var actionLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                HStack(spacing: 16, alignItems: .center) {
                    titleNode
                        .flexShrink(0.00000000001)
                    //                    dateStartedNode

                    Spacer()

                    HStack(spacing: 12) {
                        if project.finalMark != nil {
                            markNode
                        } else {
                            inProgressNode
                        }

                        chevronNode
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)

                if !isLast {
                    separatorNode
                        .padding(.left, 16)
                } else {
                    ASLayoutSpec()
                }
            }
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            actionNode
        }
    }
}
