//
//  SCTextFieldNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import SCAssets
import SFSafeSymbols
import TextureUI
import UIKit

open class SCTextFieldNode: SCActionNode, ASEditableTextNodeDelegate {
    public typealias SCEditableTextBlock = ((SCEditableTextNode) -> Void)
    public typealias SCEditableTextBoolBlock = ((SCEditableTextNode) -> Bool)

    // MARK: - Text Field

    lazy var textNode: SCEditableTextNode = {
        var node = SCEditableTextNode()

        node.multipleLines = false
        node.scrollEnabled = false
        node.isUserInteractionEnabled = false

        node.didBeginEditingBlock = { node in node.isUserInteractionEnabled = true }

        node.didFinishEditingBlock = { node in node.isUserInteractionEnabled = false }

        node.onDidLoad { [weak self] node in
            guard let textContainerInset = self?.textContainerInset,
                let node = node as? SCEditableTextNode
            else { return }

            node.textContainerInset = textContainerInset
        }

        return node
    }()

    public enum TextFieldStyle {
        case normal, success, failure
    }

    open var textFieldStyle: TextFieldStyle {
        didSet {
            transitionLayout(withAnimation: true, shouldMeasureAsync: false)
        }
    }

    override open var tintColor: UIColor! {
        didSet {
            guard let tintColor = tintColor, tintColor != oldValue else { return }

            ASPerformBlockOnMainThread { [weak self] in
                self?.textNode.tintColor = tintColor
            }
        }
    }

    open var typography: SCTypography {
        get { textNode.typography }

        set { textNode.typography = newValue }
    }

    open var placeholderColor: UIColor {
        get { textNode.placeholderColor }

        set { textNode.placeholderColor = newValue }
    }

    // MARK: - Text

    public var text: String? {
        get { textNode.text }

        set { textNode.text = newValue }
    }

    public var placeholderText: String? {
        get { textNode.placeholderText }

        set { textNode.placeholderText = newValue }
    }

    open var attributedText: NSAttributedString? {
        get { textNode.attributedText }

        set { textNode.attributedText = newValue }
    }

    open var attributedPlaceholderText: NSAttributedString? {
        get { textNode.attributedPlaceholderText }

        set { textNode.attributedPlaceholderText = newValue }
    }

    open var multipleLines: Bool {
        get { textNode.multipleLines }

        set(multipleLines) {
            textNode.multipleLines = multipleLines
        }
    }

    open var maximumLinesToDisplay: UInt {
        get { textNode.maximumLinesToDisplay }

        set(maximumLinesToDisplay) {
            textNode.maximumLinesToDisplay = maximumLinesToDisplay
        }
    }

    public var isRTL: Bool { textNode.isRTL }

    // MARK: - Actions

    open var shouldBeginEditingBlock: SCEditableTextBoolBlock? {
        get { textNode.shouldBeginEditingBlock }

        set { textNode.shouldBeginEditingBlock = newValue }
    }

    open var shouldReturnBlock: SCEditableTextBlock? {
        get { textNode.shouldReturnBlock }

        set { textNode.shouldReturnBlock = newValue }
    }

    open var shouldChangeTextBlock: ((SCEditableTextNode, NSRange, String) -> Bool)? {
        get { textNode.shouldChangeTextBlock }

        set { textNode.shouldChangeTextBlock = newValue }
    }

    open var didBeginEditingBlock: SCEditableTextBlock? {
        get { textNode.didBeginEditingBlock }

        set { textNode.didBeginEditingBlock = newValue }
    }

    open var didUpdateTextBlock: SCEditableTextBlock?

    open var didFinishEditingBlock: SCEditableTextBlock? {
        get { textNode.didFinishEditingBlock }

        set { textNode.didFinishEditingBlock = newValue }
    }

    // MARK: - Icon

    open var iconSize = ASLayoutSize(
        width: 14,
        height: 14
    ) {
        didSet { iconNode.style.preferredLayoutSize = iconSize }
    }

    open var iconInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)

    open var iconImage: UIImage? { didSet { iconNode.image = iconImage } }

    open var iconSymbol: (symbol: SFSymbol, configuration: UIImage.Configuration?)? {
        didSet {
            guard let iconSymbol = iconSymbol else {
                if oldValue != nil { iconImage = nil }

                return
            }

            let image = UIImage(
                systemSymbol: iconSymbol.symbol,
                withConfiguration: iconSymbol.configuration
            )
            .withRenderingMode(.alwaysTemplate)

            iconImage = image
        }
    }

    // MARK: - Settings

    open var spacing = CGFloat(8)

    open var autocapitalizationType: UITextAutocapitalizationType {
        get { textNode.autocapitalizationType }

        set { textNode.autocapitalizationType = newValue }
    }

    open var autocorrectionType: UITextAutocorrectionType {
        get { textNode.autocorrectionType }

        set { textNode.autocorrectionType = newValue }
    }

    open var spellCheckingType: UITextSpellCheckingType {
        get { textNode.spellCheckingType }

        set { textNode.spellCheckingType = newValue }
    }

    open var keyboardType: UIKeyboardType {
        get { textNode.keyboardType }

        set { textNode.keyboardType = newValue }
    }

    open var keyboardAppearance: UIKeyboardAppearance {
        get { textNode.keyboardAppearance }

        set { textNode.keyboardAppearance = newValue }
    }

    open var returnKeyType: UIReturnKeyType {
        get { textNode.returnKeyType }

        set { textNode.returnKeyType = newValue }
    }

    open var enablesReturnKeyAutomatically: Bool {
        get { textNode.enablesReturnKeyAutomatically }

        set { textNode.enablesReturnKeyAutomatically = newValue }
    }

    open var typingAttributes: [String: Any]? {
        get { textNode.typingAttributes }

        set { textNode.typingAttributes = newValue }
    }

    open var textDelegate: UITextViewDelegate? {
        get { textNode.textView.delegate }

        set { textNode.textView.delegate = newValue }
    }

    lazy var iconNode: SCImageNode = {
        let node = SCImageNode()

        node.contentMode = .center

        node.style.preferredLayoutSize = iconSize

        return node
    }()

    open lazy var textContainerInset: UIEdgeInsets = {
        guard
            let paragraphStyle = typography.scTextAttributes.attributes[.paragraphStyle]
                as? NSParagraphStyle
        else { return .zero }

        let minHeight = textNode.constrainedSizeForCalculatedLayout.min.height
        let minLineHeight = paragraphStyle.minimumLineHeight
        let minVerticalInsets = max(0, minHeight - minLineHeight)

        let maxHeight = textNode.constrainedSizeForCalculatedLayout.max.height
        let maxLineHeight = paragraphStyle.maximumLineHeight
        let maxVerticalInsets = max(0, maxHeight - maxLineHeight)

        let verticalInset: CGFloat = {
            if minVerticalInsets != .infinity, maxVerticalInsets != .infinity {
                return max(minVerticalInsets, maxVerticalInsets) / 2
            } else {
                return 12
            }
        }()

        return UIEdgeInsets(
            top: verticalInset,
            left: verticalInset,
            bottom: verticalInset,
            right: verticalInset
        )
    }()

    public init(
        typography: SCTypography = .input,
        textFieldStyle: TextFieldStyle = .normal,
        tintColor: UIColor = Asset.Colors.neutral50.color,
        placeholderColor: UIColor = Asset.Colors.neutral40.color,
        backgroundColor: UIColor = Asset.Colors.neutral10.color,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        autocorrectionType: UITextAutocorrectionType = .default,
        spellCheckingType: UITextSpellCheckingType = .default
    ) {
        self.textFieldStyle = textFieldStyle

        super.init()

        self.typography = typography
        self.placeholderColor = placeholderColor
        self.tintColor = tintColor

        self.normalBackgroundColor = backgroundColor

        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellCheckingType = spellCheckingType

        typingAttributes = typography.scTextAttributes.with(color: tintColor).typingAttributes

        updateBorder()

        textNode.didUpdateTextBlock = { [weak self] in
            guard let self = self else { return }

            self.didUpdateTextBlock?($0)

            self.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
        }
    }

    override open func touchUpInside(_ controlNode: ASControlNode) {
        super.touchUpInside(controlNode)

        _ = textNode.becomeFirstResponder()
    }

    override open func canBecomeFirstResponder() -> Bool { textNode.canBecomeFirstResponder() }

    override open func becomeFirstResponder() -> Bool { textNode.becomeFirstResponder() }

    override open func canResignFirstResponder() -> Bool { textNode.canResignFirstResponder() }

    override open func resignFirstResponder() -> Bool { textNode.resignFirstResponder() }

    override open func isFirstResponder() -> Bool { textNode.isFirstResponder() }

    open func setCursor(to offset: Int) { textNode.setCursor(to: offset) }

    override open func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
        guard iconImage != nil else {
            return LayoutSpec {
                HStack(alignItems: .stretch, isConcurrent: true) {
                    textNode
                        .flexGrow(1)
                }
            }
        }

        textNode.textContainerInset.right = spacing

        return LayoutSpec {
            HStack(alignItems: .center, isConcurrent: true) {
                textNode
                    .flexGrow(1)

                iconNode
                    .padding(iconInsets)
            }
        }
    }

    open override func animateLayoutTransition(_ context: ASContextTransitioning) {
        if !context.isAnimated() {
            updateBorder()

            context.completeTransition(true)
        } else {
            UIView.animate(
                withDuration: 0.24,
                delay: 0,
                options: [.allowUserInteraction, .beginFromCurrentState]
            ) { [weak self] in

                self?.updateBorder()
            } completion: { didComplete in
                context.completeTransition(didComplete)
            }

        }
    }

    func updateBorder() {
        switch textFieldStyle {
        case .normal:
            normalBorder = SCBorder(color: .clear, width: 2, radius: 8)

        case .success:
            normalBorder = SCBorder(color: Asset.Colors.green50.color, width: 2, radius: 8)

        case .failure:
            normalBorder = SCBorder(color: Asset.Colors.red50.color, width: 2, radius: 8)

        }
    }
}
