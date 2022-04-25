//
//  SCEditableTextNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import SCAssets
import UIKit

open class SCEditableTextNode: ASEditableTextNode, SCElement, ASEditableTextNodeDelegate {
    public typealias SCEditableText = ((SCEditableTextNode) -> Void)
    public typealias SCEditableTextBoolBlock = ((SCEditableTextNode) -> Bool)

    open var typography: SCTypography

    // MARK: - Tint Color

    private var _tintColor: UIColor? = nil {
        didSet {
            super.tintColor = _tintColor
        }
    }

    open override var tintColor: UIColor! {
        get {
            _tintColor
        }

        set {
            _tintColor = newValue
        }
    }

    open var placeholderColor: UIColor

    public var text: String? {
        get {
            attributedText?.string
        }

        set {
            guard let string = newValue else {
                return
            }

            attributedText = NSAttributedString(
                string: string,
                attributes: typography.scTextAttributes.with(color: tintColor).attributes
            )
        }
    }

    public var placeholderText: String? {
        get {
            attributedPlaceholderText?.string
        }

        set {
            guard let string = newValue else {
                return
            }

            attributedPlaceholderText = NSAttributedString(
                string: string,
                attributes: typography.scTextAttributes.with(color: placeholderColor).attributes
            )
        }
    }

    open var multipleLines = true {
        didSet {
            let textAttributes = typography.scTextAttributes.with(color: tintColor)

            if !multipleLines {
                typingAttributes = textAttributes.typingAttributes
            } else {
                typingAttributes = textAttributes.with(lineBreak: .none).typingAttributes
            }
        }
    }

    public var isRTL: Bool {
        guard let text = self.textView.text, !text.isEmpty else {
            return false
        }

        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)

        tagger.string = text

        let lang = tagger.tag(at: 0, scheme: .language, tokenRange: nil, sentenceRange: nil)

        guard let lang = lang?.rawValue,
            lang.contains("he") || lang.contains("ar") || lang.contains("fa")
        else {
            return false
        }
        return true
    }

    open var shouldBeginEditingBlock: SCEditableTextBoolBlock?
    open var shouldReturnBlock: SCEditableText?
    open var shouldChangeTextBlock: ((SCEditableTextNode, NSRange, String) -> Bool)?
    open var didBeginEditingBlock: SCEditableText?
    open var didUpdateTextBlock: SCEditableText?
    open var didFinishEditingBlock: SCEditableText?

    public init(
        typography: SCTypography = .input,
        tintColor: UIColor = Asset.Colors.neutral50.color,
        placeholderColor: UIColor = Asset.Colors.neutral40.color,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        autocorrectionType: UITextAutocorrectionType = .default,
        spellCheckingType: UITextSpellCheckingType = .default
    ) {
        self.typography = typography
        self.placeholderColor = placeholderColor

        super.init()

        self.typography = typography
        self.placeholderColor = placeholderColor
        self.tintColor = tintColor

        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellCheckingType = spellCheckingType

        typingAttributes = typography.scTextAttributes.with(color: tintColor).typingAttributes

        delegate = self
    }

    public override init(
        textKitComponents: ASTextKitComponents,
        placeholderTextKitComponents: ASTextKitComponents
    ) {
        self.typography = .input
        self.placeholderColor = Asset.Colors.neutral40.color

        super
            .init(
                textKitComponents: textKitComponents,
                placeholderTextKitComponents: placeholderTextKitComponents
            )
    }

    open func setCursor(to offset: Int) {
        if let newPosition = textView.position(from: textView.beginningOfDocument, offset: offset) {
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
    }

    // MARK: - ASEditableTextNodeDelegate

    open func editableTextNode(
        _: ASEditableTextNode,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text.rangeOfCharacter(from: .newlines) != nil { shouldReturnBlock?(self) }

        let shouldChangeMultipleLinesBlock: ((SCEditableTextNode, NSRange, String) -> Bool) = {
            (textNode, range, _) in

            let zeroWidthSpace = "\u{200B}"

            guard let editedText = textNode.attributedText else { return true }

            let newlineRange = NSRange(
                location: max(0, range.location - 1),
                length: min(editedText.string.count, range.length + 1)
            )

            guard editedText.attributedSubstring(from: range).string.contains(zeroWidthSpace),
                editedText.attributedSubstring(from: newlineRange).string.contains("\n")
            else {
                return true
            }

            var editedString = editedText.string

            guard let bounds = Range<String.Index>(newlineRange, in: editedText.string) else {
                return true
            }

            editedString.replaceSubrange(bounds, with: text)

            textNode.attributedText = NSAttributedString(
                string: editedString,
                attributes: textNode.typography.scTextAttributes.attributes
            )

            return false
        }

        if let shouldChangeTextBlock = shouldChangeTextBlock {
            return shouldChangeTextBlock(self, range, text)
                && shouldChangeMultipleLinesBlock(self, range, text)
        }

        return shouldChangeMultipleLinesBlock(self, range, text)
    }

    open func editableTextNodeShouldBeginEditing(_: ASEditableTextNode) -> Bool {
        if let shouldBeginEditingBlock = shouldBeginEditingBlock {
            return shouldBeginEditingBlock(self)
        }

        selectedRange = NSRange(location: attributedText?.string.count ?? 0, length: 0)

        return true
    }

    open func editableTextNodeDidBeginEditing(_: ASEditableTextNode) { didBeginEditingBlock?(self) }

    open func editableTextNodeDidUpdateText(_: ASEditableTextNode) {
        didUpdateTextBlock?(self)

        if multipleLines {
            let zeroWidthSpace = "\u{200B}"

            if var text = attributedText?.string {
                text = text.replacingOccurrences(of: "\n\(zeroWidthSpace)", with: "\n")
                text = text.replacingOccurrences(of: "\n", with: "\n\(zeroWidthSpace)")

                attributedText = NSAttributedString(
                    string: text,
                    attributes: typography.scTextAttributes.attributes
                )
            }

            if let textFieldNode = supernode as? SCTextFieldNode {
                textFieldNode.setNeedsLayout()
            }
        }
    }

    open func editableTextNodeDidFinishEditing(_: ASEditableTextNode) {
        didFinishEditingBlock?(self)
    }

    open func editableTextNodeDidChangeSelection(
        _: ASEditableTextNode,
        fromSelectedRange _: NSRange,
        toSelectedRange _: NSRange,
        dueToEditing _: Bool
    ) {}
}
