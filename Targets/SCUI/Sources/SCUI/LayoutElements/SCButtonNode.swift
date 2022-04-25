//
//  SCButtonNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import SCAssets
import SCHelpers
import SFSafeSymbols
import TextureUI
import UIKit

open class SCButtonNode: SCActionNode {
    public typealias SCButtonActionBlock = ((SCActionNode) -> Void)

    // MARK: - Button Style

    public enum ButtonStyle {
        case tinted, gray, light, outlined, linkGray, linkLight
    }

    public var buttonStyle: ButtonStyle? {
        didSet {
            updateButtonStyle(buttonStyle)
        }
    }

    func updateButtonStyle(_ buttonStyle: ButtonStyle?) {
        switch buttonStyle {

        case .tinted:
            style.height = 48

            normalBackgroundColor = Asset.Colors.tiffany50.color
            normalBorder = SCBorder(radius: 8)
            normalTextColor = Asset.Colors.neutral0.color

            typography = .button3
            highlightedTypography = .button3
            disabledTypography = .button3

        case .gray:
            style.height = 48

            normalBackgroundColor = Asset.Colors.neutral20.color
            normalBorder = SCBorder(radius: 8)
            normalTextColor = Asset.Colors.neutral50.color

            typography = .button3
            highlightedTypography = .button3
            disabledTypography = .button3

        case .light:
            style.height = 48

            normalBackgroundColor = Asset.Colors.neutral0.color
            normalBorder = SCBorder(radius: 8)
            normalTextColor = Asset.Colors.neutral50.color

            typography = .button3
            highlightedTypography = .button3
            disabledTypography = .button3

        case .outlined:
            style.height = 32

            normalBackgroundColor = .clear

            normalBorder = SCBorder(
                color: Asset.Colors.neutral30.color,
                width: 1,
                radius: 6
            )

            normalTextColor = Asset.Colors.neutral50.color

            typography = .button4
            highlightedTypography = .button4
            disabledTypography = .button4

        case .linkGray:
            style.height = 32

            normalBackgroundColor = Asset.Colors.neutral20.color
            normalBorder = SCBorder(radius: 6)
            normalTextColor = Asset.Colors.neutral50.color

            customTitleLeftNode = {
                let node = SCImageNode()

                node.style.preferredLayoutSize = ASLayoutSize(
                    width: 17,
                    height: 20
                )

                node.tintColor = Asset.Colors.neutral40.color

                node.image = UIImage(
                    systemSymbol: .arrowUpForwardApp,
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
                )
                .withRenderingMode(.alwaysTemplate)

                node.contentMode = .center

                return node
            }()

            customTitleNodesSpacing = (left: 4, right: 4)

            typography = .button5
            highlightedTypography = .button5
            disabledTypography = .button5

        case .linkLight:
            style.height = 32

            normalBackgroundColor = Asset.Colors.neutral0.color
            normalTextColor = Asset.Colors.neutral50.color

            typography = .button5
            highlightedTypography = .button5
            disabledTypography = .button5

        default:
            break
        }
    }

    // MARK: - Button Size

    public enum Size {
        case xs, s, m
    }

    public var size: Size? {
        didSet {
            updateSize(size: size)
        }
    }

    func updateSize(size: Size?) {
        guard let size = size else {
            return
        }

        switch size {

        case .xs:
            style.height = 32

            if buttonStyle == .outlined {
                normalBorder = SCBorder(
                    color: Asset.Colors.neutral30.color,
                    width: 1,
                    radius: 6
                )
            } else {
                normalBorder = SCBorder(radius: 6)
            }

            typography = .button5
            highlightedTypography = .button5
            disabledTypography = .button5

        case .s:
            style.height = 32

            if buttonStyle == .outlined {
                normalBorder = SCBorder(
                    color: Asset.Colors.neutral30.color,
                    width: 1,
                    radius: 6
                )
            } else {
                normalBorder = SCBorder(radius: 6)
            }

            typography = .button4
            highlightedTypography = .button4
            disabledTypography = .button4

        case .m:
            style.height = 48

            if buttonStyle == .outlined {
                normalBorder = SCBorder(
                    color: Asset.Colors.neutral30.color,
                    width: 1,
                    radius: 8
                )
            } else {
                normalBorder = SCBorder(radius: 8)
            }

            typography = .button3
            highlightedTypography = .button3
            disabledTypography = .button3

        }
    }

    // MARK: - Padding

    public var horizontalPadding: CGFloat? {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Interface States

    override open var isEnabled: Bool { willSet { isDisabled = !newValue } }

    /// *isEnabled* alternative that allows to interact with button through **disabled** action blocks
    override open var isDisabled: Bool {
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

            if isHighlighted { setHighlightedState() } else { setNormalState() }
        }
    }

    open var isLoading: Bool = false {
        didSet {
            guard isLoading != oldValue else { return }

            if transition.contains(.haptic), transition.haptic.isTimedOut {
                transition.haptic.selectionChanged()
            }

            if loaderNode?.color == nil {
                if !isDisabled, let normalTextColor = normalTextColor {
                    loaderNode?.color = normalTextColor
                } else if let disabledTextColor = disabledTextColor {
                    loaderNode?.color = disabledTextColor
                }
            }

            setLoadingState(isLoading)
        }
    }

    // MARK: - Title

    internal lazy var titleNode: SCTextNode = {
        let node = SCTextNode(typography: typography)

        node.style.flexShrink = 1.0

        return node
    }()

    open var titleAlignment = (
        ASRelativeLayoutSpecPosition.center, ASRelativeLayoutSpecPosition.center
    )

    open lazy var typography: SCTypography = .button2
    open lazy var highlightedTypography: SCTypography = typography
    open lazy var disabledTypography: SCTypography = typography

    open var normalTextColor: UIColor?
    open var highlightedTextColor: UIColor?
    open var disabledTextColor: UIColor?

    open var normalText: String? {
        didSet {
            if !isDisabled, !isHighlighted {
                guard let text = normalText else { return }

                let scTextAttributes = typography.scTextAttributes.with(color: normalTextColor)

                titleNode.attributedText = NSAttributedString(
                    string: text,
                    attributes: scTextAttributes.attributes
                )
            }
        }
    }

    open var disabledText: String? {
        didSet {
            if isDisabled {
                guard let text = disabledText else { return }

                let scTextAttributes = typography.scTextAttributes.with(
                    color: disabledTextColor
                )

                titleNode.attributedText = NSAttributedString(
                    string: text,
                    attributes: scTextAttributes.attributes
                )
            }
        }
    }

    open var highlightedText: String? {
        didSet {
            if !isDisabled, isHighlighted {
                guard let text = highlightedText else { return }

                let scTextAttributes = typography.scTextAttributes.with(
                    color: highlightedTextColor
                )

                titleNode.attributedText = NSAttributedString(
                    string: text,
                    attributes: scTextAttributes.attributes
                )
            }
        }
    }

    // MARK: - Image

    internal lazy var imageNode: SCImageNode = {
        let node = SCImageNode()

        node.contentMode = imageContentMode

        return node
    }()

    open var imageAlignment = (
        ASRelativeLayoutSpecPosition.center, ASRelativeLayoutSpecPosition.center
    )

    open var systemSymbol: (symbol: SFSymbol, configuration: UIImage.Configuration?)? {
        didSet {
            guard let systemSymbol = systemSymbol else {
                if oldValue != nil { normalImage = nil }

                return
            }

            let image = UIImage(
                systemSymbol: systemSymbol.symbol,
                withConfiguration: systemSymbol.configuration
            )
            .withRenderingMode(.alwaysTemplate)

            onDidLoad { node in
                guard let buttonNode = node as? SCButtonNode else { return }

                buttonNode.normalImage = image
            }
        }
    }

    open var normalImage: UIImage? {
        didSet { if !isDisabled, !isHighlighted { imageNode.image = normalImage } }
    }

    open var disabledImage: UIImage? {
        didSet { if isDisabled { imageNode.image = disabledImage } }
    }

    open var highlightedImage: UIImage? {
        didSet { if !isDisabled, isHighlighted { imageNode.image = highlightedImage } }
    }

    open var imageContentMode: UIView.ContentMode = .center {
        didSet { imageNode.contentMode = imageContentMode }
    }

    // MARK: - Loader

    open lazy var loaderNode: SCLoaderNode? = {
        let node = SCLoaderNode(style: .medium, color: loaderColor)

        node.onDidLoad { node in guard let node = node as? SCLoaderNode else { return }

            node.stopAnimating()
        }

        return node
    }()

    open var loaderAlignment = (
        ASRelativeLayoutSpecPosition.center, ASRelativeLayoutSpecPosition.center
    )

    open var loaderColor: UIColor?

    // MARK: - Tint Color

    override open var tintColor: UIColor! {
        didSet {
            guard let tintColor = tintColor, tintColor != oldValue else { return }

            if isInDisplayState {
                titleNode.tintColor = tintColor
                imageNode.tintColor = tintColor
                loaderNode?.tintColor = tintColor
            } else {
                onDidLoad { node in
                    guard let node = node as? SCButtonNode else { return }

                    node.titleNode.tintColor = tintColor
                    node.imageNode.tintColor = tintColor
                    node.loaderNode?.tintColor = tintColor
                }
            }
        }
    }

    // MARK: - Init

    public init(
        buttonStyle: ButtonStyle? = .tinted,
        size: Size? = nil
    ) {
        self.buttonStyle = buttonStyle
        self.size = size

        super.init()

        updateButtonStyle(buttonStyle)
        updateSize(size: size)

        backgroundColor = normalBackgroundColor

        if let normalBorder = normalBorder { border = normalBorder }

        imageNode.image = normalImage
    }

    // MARK: - Custom Nodes

    open var customTitleLeftNode: ASDisplayNode?

    open var customTitleRightNode: ASDisplayNode?

    open var customTitleNodesSpacing: (left: CGFloat, right: CGFloat) = (left: 5, right: 5)

    // MARK: - Did Load

    override open func didLoad() { super.didLoad() }

    // MARK: - Layout

    var mainStack: some LayoutElement {
        ZStack {
            imageNode
                .flexGrow(1)
                .relativePosition(horizontal: imageAlignment.0, vertical: imageAlignment.1)

            HStack(alignItems: .center) {
                customTitleLeftNode?
                    .spacingAfter(customTitleNodesSpacing.left)

                titleNode

                customTitleRightNode?
                    .spacingBefore(customTitleNodesSpacing.right)
            }
            .relativePosition(horizontal: titleAlignment.0, vertical: titleAlignment.1)

            loaderNode
                .relativePosition(
                    horizontal: loaderAlignment.0,
                    vertical: loaderAlignment.1
                )
        }
        .padding(.horizontal, horizontalPadding)
    }

    override open func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            if contextMenu == nil {
                mainStack
            } else {
                mainStack
                    .overlay(contextNode)
            }
        }
    }
}

// MARK: - State Workers

extension SCButtonNode {
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

        if let text = normalText {
            let animation = CATransition()

            animation.timingFunction = CAMediaTimingFunction(name: .default)
            animation.type = .fade
            animation.duration = touchAnimationDuration

            titleNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

            titleNode.attributedText = NSAttributedString(
                string: text,
                attributes: typography.scTextAttributes.with(color: normalTextColor).attributes
            )
        }

        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.type = .fade
        animation.duration = touchAnimationDuration

        imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

        if systemSymbol != nil {
            imageNode.tintColor = tintColor
        } else if let normalImage = normalImage {
            imageNode.image = normalImage
        }
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

        if let text = highlightedText ?? normalText {
            titleNode.attributedText = NSAttributedString(
                string: text,
                attributes: typography.scTextAttributes
                    .with(color: highlightedTextColor ?? normalTextColor?.highlighted).attributes
            )
        }

        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.type = .fade
        animation.duration = touchAnimationDuration

        if systemSymbol != nil {
            imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

            imageNode.tintColor = tintColor.highlighted
        } else if let highlightedImage = highlightedImage ?? normalImage {
            imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

            imageNode.image = highlightedImage
        }
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

        if let text = disabledText ?? normalText {
            let animation = CATransition()

            animation.timingFunction = CAMediaTimingFunction(name: .default)
            animation.type = .fade
            animation.duration = touchAnimationDuration

            ASPerformBlockOnMainThread { [weak self] in
                self?.titleNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)
            }

            titleNode.attributedText = NSAttributedString(
                string: text,
                attributes: typography.scTextAttributes.with(color: disabledTextColor).attributes
            )
        }

        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.type = .fade
        animation.duration = touchAnimationDuration

        if systemSymbol != nil {
            imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

            imageNode.tintColor = tintColor.disabled
        } else if let disabledImage = disabledImage ?? normalImage {
            imageNode.layer.add(animation, forKey: CATransitionType.fade.rawValue)

            imageNode.image = disabledImage
        }
    }

    fileprivate func setLoadingState(_ isLoading: Bool) {
        isUserInteractionEnabled = !isLoading

        ASPerformBlockOnMainThread { [weak self] in guard let self = self else { return }

            UIView.animate(withDuration: self.touchAnimationDuration) {
                self.titleNode.alpha = isLoading ? 0 : 1
                self.customTitleLeftNode?.alpha = isLoading ? 0 : 1
                self.customTitleRightNode?.alpha = isLoading ? 0 : 1
                self.imageNode.alpha = isLoading ? 0 : 1
            }

            let animation = CATransition()

            animation.timingFunction = CAMediaTimingFunction(name: .default)
            animation.type = .fade
            animation.duration = self.touchAnimationDuration

            self.loaderNode?.layer.add(animation, forKey: CATransitionType.fade.rawValue)

            if isLoading {
                self.loaderNode?.startAnimating()
            } else {
                self.loaderNode?.stopAnimating()
            }
        }
    }
}
