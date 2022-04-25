//
//  SCProfileLevelNode.swift
//  SCProfile
//
//  Created by Nikita Arutyunov on 12.04.2022.
//

import AsyncDisplayKit
import SCAssets
import SCHelpers
import SCUI
import TextureUI

class SCProfileLevelNode: SCActionNode {
    // MARK: - Shimmer

    var isShimmering = true {
        didSet {
            ASPerformBlockOnMainThread { [weak self] in
                guard let self = self else { return }

                self.shimmerNode.alpha = self.isShimmering ? 1 : 0
            }
        }
    }

    lazy var shimmerNode: ShimmerEffectNode = {
        let node = ShimmerEffectNode()

        return node
    }()

    func shimmerUpdate() {
        shimmerNode.update(
            backgroundColor: .clear,
            foregroundColor: Asset.Colors.neutral20.color,
            shimmeringColor: Asset.Colors.neutral10.color,
            shapes: [
                .roundedRect(rect: progressNode.frame, cornerRadius: cornerRadius)
            ],
            horizontal: true,
            size: shimmerNode.calculatedSize
        )

        shimmerNode.updateAbsoluteRect(
            CGRect(origin: .zero, size: shimmerNode.calculatedSize),
            within: calculatedSize
        )
    }

    // MARK: - Progress

    lazy var progressNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(width: .auto, height: .fraction(1))

        node.backgroundColor = Asset.Colors.tiffany50.color

        return node
    }()

    // MARK: - Light Mask

    lazy var lightMaskNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(width: .auto, height: .fraction(1))

        node.backgroundColor = Asset.Colors.neutral0.color

        return node
    }()

    // MARK: - Title

    lazy var titleNode: SCTextNode = {
        let node = SCTextNode(typography: .caption1)

        node.text = levelText

        return node
    }()

    // MARK: - Masked Title

    lazy var maskedTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .caption1)

        node.text = levelText

        return node
    }()

    // MARK: - Level

    var level: Decimal? {
        didSet {
            titleNode.text = levelText
            maskedTitleNode.text = levelText

            ASPerformBlockOnMainThread { [weak self] in
                self?.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
            }

            isShimmering = false
        }
    }

    var normalizedLevel: (Int, Int) {
        guard let level = level else {
            return (0, 0)
        }

        guard let percentageSub = level.description(with: 2).split(separator: ".").last,
            let percentage = Int(String(percentageSub))
        else { return (level.intValue, 0) }

        return (level.intValue, percentage)
    }

    var percentage: CGFloat {
        level?.doubleValue.truncatingRemainder(dividingBy: 1) ?? 0
    }

    var levelText: String {
        "level \(normalizedLevel.0) - \(normalizedLevel.1)%"
    }

    // MARK: - Init

    override init() {
        super.init()
    }

    // MARK: - Layout Did Finish

    override func layoutDidFinish() {
        super.layoutDidFinish()

        lightMaskNode.layer.mask = titleNode.layer

        shimmerUpdate()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            ZStack {
                HStack {
                    progressNode
                        .flexBasis(.fraction(percentage))

                    Spacer()
                }

                maskedTitleNode
                    .relativePosition(horizontal: .center, vertical: .center)

                HStack {
                    lightMaskNode
                        .flexBasis(.fraction(percentage))

                    Spacer()
                }

                titleNode
                    .relativePosition(horizontal: .center, vertical: .center)
            }
            .overlay(shimmerNode)
        }
    }
}
