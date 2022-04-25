//
//  BasicUserCellNode.swift
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

class BasicUserCellNode: SCCellNode {

    let user: BasicUser

    // MARK: - Avatar

    lazy var avatarNode: SCAvatarNode = {
        let letters = [user.firstName, user.lastName]
            .compactMap { name -> String? in
                guard let firstLetter = name?.first else {
                    return nil
                }

                return String(firstLetter).capitalized
            }

        let avatarURL: URL? = {
            guard let avatar = user.imageURL else { return nil }

            return URL(string: avatar)
        }()

        let node = SCAvatarNode(
            size: .l,
            letters: letters,
            url: avatarURL
        )

        return node
    }()

    // MARK: - Name

    lazy var nameNode: SCTextNode = {
        let node = SCTextNode()

        node.typography = node.typography.with(lineBreak: NSLineBreakMode.byTruncatingTail)

        node.tintColor = Asset.Colors.neutral50.color

        node.text = user.displayName?.trimmingBlank ?? "User"

        return node
    }()

    // MARK: - Login

    lazy var loginNode: SCTextNode = {
        let node = SCTextNode(typography: .caption2)

        node.tintColor = Asset.Colors.neutral40.color

        node.text = user.login?.trimmingBlank ?? "—"

        return node
    }()

    let action: SCActionNode?

    // MARK: - Init

    init(
        user: BasicUser,
        action: SCActionNode? = nil
    ) {
        self.user = user
        self.action = action
    }

    // MARK: - Layout Did Finish

    override func layoutDidFinish() {
        super.layoutDidFinish()

        guard isShimmering else { return }

        shimmerShapes = [
            .circle(
                CGRect(
                    origin: avatarNode.convert(.zero, to: self),
                    size: avatarNode.calculatedSize
                )
            ),
            .roundedRectLine(
                startPoint: nameNode.convert(.zero, to: self),
                width: 200,
                diameter: 16
            ),
            .roundedRectLine(
                startPoint: loginNode.convert(.zero, to: self),
                width: 120,
                diameter: 16
            ),
        ]
    }

    // MARK: - Layout Spec

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            HStack(spacing: 16, alignItems: .center) {
                avatarNode

                VStack {
                    HStack {
                        nameNode
                            .flexShrink(0.00000000001)
                    }

                    HStack {
                        loginNode
                            .flexShrink(0.00000000001)
                    }
                }

                if let action = action {
                    Spacer()

                    action
                } else {
                    ASLayoutSpec()
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(shimmerNode)
        }
    }
}
