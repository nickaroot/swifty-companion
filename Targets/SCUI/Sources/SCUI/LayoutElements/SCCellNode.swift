//
//  SCCellNode.swift
//
//
//  Created by Nikita Arutyunov on 03.01.2022.
//

import AsyncDisplayKit
import SCAssets
import TextureUI
import UIKit

open class SCCellNode: ASCellNode, SCElement {

    // MARK: - Collection

    open var collectionNode: ASCollectionNode? {
        guard ASDisplayNodeThreadIsMain() else { return nil }

        guard
            let cellViewLayer = layer.superlayer?.superlayer,
            let collectionView = cellViewLayer.superlayer?.delegate as? ASCollectionView
        else {
            return nil
        }

        return collectionView.collectionNode
    }

    // MARK: - Shimmer

    open var isShimmering = false {
        didSet {
            shimmerNode.alpha = isShimmering ? 1 : 0
        }
    }

    open lazy var shimmerNode: ShimmerEffectNode = {
        let node = ShimmerEffectNode()

        node.alpha = 0

        return node
    }()

    open var shimmerShapes = [ShimmerEffectNode.Shape]()

    open func shimmerUpdate() {
        shimmerNode.update(
            backgroundColor: Asset.Colors.neutral0.color,
            foregroundColor: Asset.Colors.neutral10.color,
            shimmeringColor: Asset.Colors.neutral0.color,
            shapes: shimmerShapes,
            horizontal: true,
            size: shimmerNode.calculatedSize
        )

        guard let collectionNode = collectionNode else { return }

        let origin: CGPoint = collectionNode.layer.convert(.zero, from: layer)
        let containerSize = collectionNode.calculatedSize

        shimmerNode.updateAbsoluteRect(
            CGRect(origin: origin, size: shimmerNode.calculatedSize),
            within: containerSize
        )
    }

    // MARK: - Interface States

    open var transition: SCActionTransition = [.highlight, .haptic]

    open override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }

            if transition.contains(.scale) {
                ASPerformBlockOnMainThread { [weak self] in
                    self?.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
                }
            }

            if transition.contains(.haptic),
                isHighlighted || transition.haptic.isTimedOut
            {

                transition.haptic.impactOccured(isHighlighted: isHighlighted)
            }
        }
    }

    // MARK: - Loader

    open var isLoading: Bool = false {
        didSet {
            guard isLoading != oldValue else { return }

            if transition.contains(.haptic),
                transition.haptic.isTimedOut
            {

                transition.haptic.selectionChanged()
            }

            setLoadingState(isLoading)
        }
    }

    open lazy var loaderNode: SCLoaderNode = {
        SCLoaderNode(style: .medium, color: Asset.Colors.neutral40.color)
    }()

    // MARK: - Node

    open var modelHash: Int?

    public override init() {
        super.init()

        automaticallyManagesSubnodes = true

        addActions()
    }

    // MARK: - Transition

    open override func animateLayoutTransition(_ context: ASContextTransitioning) {
        if context.isAnimated() {
            if transition.contains(.scale) {
                let scale = isHighlighted ? transition.scale.factor : 1

                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
                }
            }
        } else {
            super.animateLayoutTransition(context)
        }
    }

    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            ZStack {
                super.layoutSpecThatFits(constrainedSize)

                loaderNode.relativePosition(horizontal: .center, vertical: .center)
            }
        }
    }

    // MARK: - Actions

    open func addActions() {}
}

extension SCCellNode {
    fileprivate func setLoadingState(_ isLoading: Bool) {
        isUserInteractionEnabled = !isLoading

        let touchAnimationDuration = 0.24

        ASPerformBlockOnMainThread { [weak self] in
            guard let self = self else { return }

            let animation = CATransition()

            animation.timingFunction = CAMediaTimingFunction(name: .default)
            animation.type = .fade
            animation.duration = touchAnimationDuration

            self.loaderNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

            if isLoading {
                self.loaderNode.startAnimating()
            } else {
                self.loaderNode.stopAnimating()
            }
        }
    }
}
