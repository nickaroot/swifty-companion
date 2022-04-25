//
//  SCBorder.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

public struct SCBorder {
    public enum RoundingType {
        case defaultSlowCALayer
        case precomposited
        case clipping

        public init(
            _ cornerRoundingType: ASCornerRoundingType
        ) {
            self = {
                switch cornerRoundingType {
                case .defaultSlowCALayer: return .defaultSlowCALayer
                case .precomposited: return .precomposited
                case .clipping: return .clipping
                @unknown default: return .defaultSlowCALayer
                }
            }()
        }

        var cornerRoundingType: ASCornerRoundingType {
            switch self {
            case .defaultSlowCALayer: return .defaultSlowCALayer
            case .precomposited: return .precomposited
            case .clipping: return .clipping
            }
        }
    }

    public struct Corners: OptionSet {
        public var rawValue: UInt

        public static var leftTop = Corners(rawValue: 1 << 0)
        public static var rightTop = Corners(rawValue: 1 << 1)
        public static var leftBottom = Corners(rawValue: 1 << 2)
        public static var rightBottom = Corners(rawValue: 1 << 3)

        public static var allLeft = Corners([.leftTop, .leftBottom])
        public static var allRight = Corners([.rightTop, .rightBottom])
        public static var allTop = Corners([.leftTop, .rightTop])
        public static var allBottom = Corners([.leftBottom, .rightBottom])

        public static var all = Corners([.leftBottom, .leftTop, .rightTop, .rightBottom])

        public static var none = Corners([])

        public init(rawValue: UInt) { self.rawValue = rawValue }

        public init(_ maskedCorners: CACornerMask) { rawValue = maskedCorners.rawValue }

        public var maskedCorners: CACornerMask { CACornerMask(rawValue: rawValue) }
    }

    public let color: UIColor
    public let width: CGFloat
    public let radius: CGFloat
    public let roundingType: RoundingType
    public let corners: Corners

    public init(
        color: UIColor = .clear,
        width: CGFloat = 0,
        radius: CGFloat = 0,
        roundingType: RoundingType = .defaultSlowCALayer,
        corners: Corners = .none
    ) {
        self.color = color
        self.width = width
        self.radius = radius
        self.roundingType = roundingType
        self.corners = corners == .none && radius != 0 ? .all : corners
    }

    public static let none = SCBorder()

    public var highlighted: Self {
        guard let hue = color.hue, let saturation = color.saturation,
            var brightness = color.brightness, let alpha = color.alpha
        else { return self }

        let factor = CGFloat(0.098)

        brightness -= brightness > 0.5 ? factor : -factor

        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)

        return Self(
            color: color,
            width: width,
            radius: radius,
            roundingType: roundingType,
            corners: corners
        )
    }

    public var disabled: Self {
        Self(
            color: color.textDisabled,
            width: width,
            radius: radius,
            roundingType: roundingType,
            corners: corners
        )
    }
}
