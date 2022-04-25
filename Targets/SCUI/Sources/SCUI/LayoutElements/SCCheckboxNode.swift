//
//  SCCheckboxNode.swift
//
//
//  Created by Nikita Arutyunov on 06.02.2022.
//

import AsyncDisplayKit
import SCAssets
import SFSafeSymbols
import TextureUI
import UIKit

public class SCCheckboxNode: SCActionNode {

    // MARK: - Tint Color

    public override var tintColor: UIColor! {
        didSet {
            imageNode.tintColor = tintColor
        }
    }

    // MARK: - Interface States

    open var isActive: Bool = false {
        didSet {
            guard isActive != oldValue, !isDisabled else { return }

            if isActive { setActiveState() } else { setNormalState() }
        }
    }

    override open var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue, !isDisabled else { return }

            if transition.contains(.scale) {
                ASPerformBlockOnMainThread { [weak self] in
                    self?.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
                }
            }

            if transition.contains(.haptic), isHighlighted || transition.haptic.isTimedOut {
                transition.haptic.impactOccured(isHighlighted: isHighlighted)
            }

            if transition.contains(.highlight) {
                if isHighlighted { setHighlightedState() } else { setNormalState() }
            }
        }
    }

    override open var isEnabled: Bool { willSet { isDisabled = !newValue } }

    /// *isEnabled* alternative that allows to interact with button through **disabled** action blocks
    open override var isDisabled: Bool {
        willSet {
            if isDisabled != newValue {
                if newValue {
                    setDisabledState()
                } else if isHighlighted {
                    setHighlightedState()
                } else {
                    setNormalState()
                }
            }
        }
    }

    // MARK: - Image

    internal var normalImage: UIImage {
        UIImage(
            systemSymbol: SFSymbol.square,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        )
        .withRenderingMode(.alwaysTemplate)
    }

    internal var highlightedImage: UIImage {
        UIImage(
            systemSymbol: SFSymbol.squareFill,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        )
        .withRenderingMode(.alwaysTemplate)
    }

    internal var activeImage: UIImage {
        UIImage(
            systemSymbol: SFSymbol.checkmarkSquareFill,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        )
        .withRenderingMode(.alwaysTemplate)
    }

    internal lazy var imageNode: SCImageNode = {
        let node = SCImageNode()

        node.contentMode = .center

        return node
    }()

    // MARK: - Init

    public override init() {
        super.init()

        style.preferredLayoutSize = ASLayoutSize(
            width: 24,
            height: 24
        )

        tintColor = Asset.Colors.neutral40.color
    }

    public init(
        isActive: Bool
    ) {
        super.init()

        self.isActive = isActive

        style.preferredLayoutSize = ASLayoutSize(
            width: 24,
            height: 24
        )

        if !isActive {
            tintColor = Asset.Colors.neutral40.color
        } else {
            tintColor = Asset.Colors.neutral50.color
        }
    }

    // MARK: - Did Load

    public override func didLoad() {
        super.didLoad()

        if !isActive {
            imageNode.image = normalImage
        } else {
            imageNode.image = activeImage
        }
    }

    // MARK: - Action Handlers

    public override func touchUpInside(_: ASControlNode) {
        super.touchUpInside(self)

        guard !isDisabled else { return }

        isActive.toggle()

        touchUpInsideBlock?(self)
    }

    // MARK: - Layout Spec

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            VStack {
                imageNode
                    .preferredLayoutSize(style.preferredLayoutSize)
            }
        }
    }
}

extension SCCheckboxNode {
    fileprivate func setNormalState() {
        if let normalBackgroundColor = normalBackgroundColor {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.backgroundColor = normalBackgroundColor }
            )
        }

        if let normalBorder = normalBorder {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.border = normalBorder }
            )
        }

        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.type = .fade
        animation.duration = touchAnimationDuration

        imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

        tintColor = Asset.Colors.neutral40.color

        imageNode.image = normalImage
    }

    fileprivate func setHighlightedState() {
        if let highlightedBackgroundColor = highlightedBackgroundColor
            ?? normalBackgroundColor?.highlighted
        {
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.backgroundColor = highlightedBackgroundColor }
            )
        }

        if let highlightedBorder = highlightedBorder ?? normalBorder?.highlighted {
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.border = highlightedBorder }
            )
        }

        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.type = .fade
        animation.duration = touchAnimationDuration

        imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

        imageNode.image = highlightedImage
    }

    fileprivate func setActiveState() {
        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.type = .fade
        animation.duration = touchAnimationDuration

        imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

        tintColor = Asset.Colors.neutral50.color

        imageNode.image = activeImage
    }

    fileprivate func setDisabledState() {
        if let disabledBackgroundColor = disabledBackgroundColor ?? normalBackgroundColor?.disabled
        {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.backgroundColor = disabledBackgroundColor }
            )
        }

        if let disabledBorder = disabledBorder ?? normalBorder?.disabled {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.border = disabledBorder }
            )
        }
    }
}
