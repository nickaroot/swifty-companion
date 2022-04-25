//
//  SCTextNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

open class SCTextNode: ASTextNode, SCElement {
    public var typography: SCTypography

    public var attributes: SCTextAttributes?

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
                attributes: attributes?.with(color: tintColor).attributes
                    ?? typography.scTextAttributes.with(color: tintColor).attributes
            )
        }
    }

    public init(
        typography: SCTypography = .body
    ) {
        self.typography = typography

        super.init()
    }
}
