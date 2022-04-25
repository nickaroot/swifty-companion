//
//  SCElement.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import SCHelpers
import UIKit

public protocol SCElement {
    var frame: CGRect { get set }

    var shadow: SCShadow { get set }

    var border: SCBorder { get set }

    func convert(_ point: CGPoint, to node: ASDisplayNode?) -> CGPoint
}

extension SCElement where Self: ASDisplayNode {
    public var shadow: SCShadow {
        get {
            let shadowColor = UIColor(cgColor: self.shadowColor ?? UIColor.clear.cgColor)

            return SCShadow(
                color: shadowColor,
                radius: shadowRadius,
                opacity: shadowOpacity,
                offset: shadowOffset
            )
        }

        set {
            clipsToBounds = false

            shadowColor = newValue.color.cgColor
            shadowRadius = newValue.radius
            shadowOpacity = newValue.opacity
            shadowOffset = newValue.offset
        }
    }

    public var border: SCBorder {
        get {
            SCBorder(
                color: borderColor?.uiColor ?? .clear,
                width: borderWidth,
                radius: cornerRadius,
                roundingType: SCBorder.RoundingType(cornerRoundingType),
                corners: SCBorder.Corners(maskedCorners)
            )
        }

        set {
            borderColor = newValue.color.cgColor
            borderWidth = newValue.width
            cornerRadius = newValue.radius
            cornerRoundingType = newValue.roundingType.cornerRoundingType
            maskedCorners = newValue.corners.maskedCorners

            ASPerformBlockOnMainThread { [weak self] in
                if newValue.roundingType == .defaultSlowCALayer {
                    self?.layer.maskedCorners = newValue.corners.maskedCorners
                }
            }
        }
    }
}
