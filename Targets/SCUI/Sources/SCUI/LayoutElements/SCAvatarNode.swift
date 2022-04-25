//
//  SCAvatarNode.swift
//
//
//  Created by Nikita Arutyunov on 02.01.2022.
//

import AsyncDisplayKit
import SCAssets
import TextureUI
import UIKit

open class SCAvatarNode: SCDisplayNode {

    // MARK: - URL

    public var url: URL? {
        get {
            imageNode.url
        }

        set(url) {
            imageNode.setURL(url, resetToDefault: true)
        }
    }

    // MARK: - Size

    public enum Size {
        case xxl, xl, l, m, s

        var diameter: CGFloat {
            switch self {
            case .xxl:
                return 128

            case .xl:
                return 64

            case .l:
                return 48

            case .m:
                return 20

            case .s:
                return 16
            }
        }

        var imageSize: CGSize {
            let diameter = self.diameter

            return CGSize(width: diameter, height: diameter)
        }

        var indicator: (diameter: CGFloat, strokeWidth: CGFloat)? {
            switch self {
            case .xxl:
                return (diameter: diameter * 0.1875, strokeWidth: 2)

            case .xl, .l:
                return (diameter: diameter * 0.25, strokeWidth: 2)

            case .m, .s:
                return nil
            }
        }

        var font: UIFont {
            switch self {
            case .xxl:
                return .systemFont(ofSize: 48, weight: .medium)
            case .xl:
                return .systemFont(ofSize: 32, weight: .medium)
            case .l:
                return .systemFont(ofSize: 20, weight: .medium)
            case .m:
                return .systemFont(ofSize: 14, weight: .medium)
            case .s:
                return .systemFont(ofSize: 12, weight: .medium)
            }
        }
    }

    public var size: Size {
        didSet {
            updateSize()
        }
    }

    // MARK: - Image

    lazy var imageNode: SCNetworkImageNode = {
        let node = SCNetworkImageNode()

        return node
    }()

    // MARK: - Indicator

    lazy var indicatorNode: SCImageNode = {
        let node = SCImageNode()

        return node
    }()

    public var isOnline: Bool {
        didSet {
            updateIndicatorImage()

            transitionLayout(withAnimation: true, shouldMeasureAsync: false)
        }
    }

    // MARK: - Init

    public init(
        size: Size = .xl,
        border: (width: CGFloat, color: UIColor?) = (0, nil),
        image: UIImage? = nil,
        url: URL? = nil,
        isOnline: Bool = false
    ) {
        self.size = size
        self.isOnline = isOnline

        super.init()

        updateSize()

        imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(
            border.width,
            border.color
        )

        imageNode.defaultImage = image

        if let url = url {
            imageNode.setURL(url, resetToDefault: true)
        }
    }

    public init(
        size: Size = .xl,
        border: (width: CGFloat, color: UIColor?) = (0, nil),
        letters: [String]? = nil,
        url: URL? = nil,
        isOnline: Bool = false
    ) {
        self.size = size
        self.isOnline = isOnline

        super.init()

        updateSize()

        imageNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(
            border.width,
            border.color
        )

        imageNode.defaultImage = generateImage(
            size.imageSize,
            rotatedContext: { contextSize, context in

                context.clear(CGRect(origin: CGPoint(), size: contextSize))

                drawPeerAvatarLetters(
                    context: context,
                    size: CGSize(width: contextSize.width, height: contextSize.height),
                    round: true,
                    attributes: SCTextAttributes(
                        color: Asset.Colors.neutral40.color,
                        font: size.font
                    ),
                    letters: letters ?? [""],
                    colors: [
                        Asset.Colors.neutral20.color,
                        Asset.Colors.neutral20.color,
                    ]
                )
            }
        )?
        .withRenderingMode(.alwaysOriginal)

        if let url = url {
            imageNode.setURL(url, resetToDefault: true)
        }
    }

    open override func asyncTraitCollectionDidChange(
        withPreviousTraitCollection previousTraitCollection: ASPrimitiveTraitCollection
    ) {
        super.asyncTraitCollectionDidChange(withPreviousTraitCollection: previousTraitCollection)

        let traitCollection = asyncTraitCollection()

        if traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle {
            updateIndicatorImage()
        }
    }

    // MARK: - Update Size

    func updateSize() {
        imageNode.style.preferredSize = size.imageSize
        imageNode.border = SCBorder(radius: size.diameter / 2)

        if let indicatorDiameter = size.indicator?.diameter {
            indicatorNode.style.preferredLayoutSize = ASLayoutSize(
                width: .points(indicatorDiameter),
                height: .points(indicatorDiameter)
            )
        } else {
            indicatorNode.style.preferredLayoutSize = ASLayoutSize(
                width: .points(0),
                height: .points(0)
            )
        }
    }

    // MARK: - Update Indicator Image

    func updateIndicatorImage() {
        if let indicator = size.indicator {
            indicatorNode.image = generateFilledCircleImage(
                diameter: indicator.diameter,
                color: Asset.Colors.green40.color,
                strokeColor: Asset.Colors.neutral0.color,
                strokeWidth: indicator.strokeWidth
            )
        } else {
            indicatorNode.image = nil
        }
    }

    // MARK: - Layout Spec

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            if let indicator = size.indicator, isOnline {
                CornerSpec(
                    corner:
                        indicatorNode
                        .padding([.left, .top], -indicator.diameter)
                        .padding([.right, .bottom], size.diameter * 0.25 - indicator.diameter),
                    location: .bottomRight
                ) {
                    imageNode
                }
            } else {
                imageNode
            }
        }
    }
}
