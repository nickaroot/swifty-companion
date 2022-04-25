//
//  SCImageNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

open class SCImageNode: ASImageNode, SCElement {
    open override var tintColor: UIColor! {
        didSet {
            guard let tintColor = tintColor else { return }

            imageModificationBlock = ASImageNodeTintColorModificationBlock(tintColor)
        }
    }

    private var _image: UIImage? {
        didSet {
            guard let _image = _image else {
                return super.image = nil
            }

            guard _image.isSymbolImage, !isInDisplayState else {
                return super.image = _image
            }

            guard let cgImage = _image.cgImage else {
                return super.image = nil
            }

            super.image = UIImage(
                cgImage: cgImage,
                scale: _image.scale,
                orientation: _image.imageOrientation
            )

            contentMode = .center
        }
    }

    open override var image: UIImage? {
        get {
            _image
        }

        set {
            self._image = newValue
        }
    }

    public override init() {
        super.init()

        isLayerBacked = true
    }
}
