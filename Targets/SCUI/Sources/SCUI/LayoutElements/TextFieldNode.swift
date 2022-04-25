//
//  TextFieldNode.swift
//  SCUI
//
//  Created by Nikita Arutyunov on 21.03.2022.
//

import AsyncDisplayKit

public final class TextFieldNodeView: UITextField {
    public var didDeleteBackwardWhileEmpty: (() -> Void)?

    public var contentInset = UIEdgeInsets.zero

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: contentInset)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        editingRect(forBounds: bounds)
    }

    override public func deleteBackward() {
        if text?.isEmpty ?? true {
            didDeleteBackwardWhileEmpty?()
        }

        super.deleteBackward()
    }

    override public var keyboardAppearance: UIKeyboardAppearance {
        get {
            super.keyboardAppearance
        }

        set {
            guard newValue != keyboardAppearance else { return }

            let resigning = isFirstResponder

            if resigning {
                resignFirstResponder()
            }

            super.keyboardAppearance = newValue

            if resigning {
                becomeFirstResponder()
            }
        }
    }
}

public class TextFieldNode: ASDisplayNode {
    public var textField: TextFieldNodeView {
        view as! TextFieldNodeView
    }

    override public init() {
        super.init()

        setViewBlock {
            TextFieldNodeView()
        }
    }
}
