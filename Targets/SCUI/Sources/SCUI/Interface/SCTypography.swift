//
//  SCTypography.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import SCAssets
import UIKit

public indirect enum SCTypography {
    case headline1, headline2, headline3, headline4

    case message

    case body

    case input

    case button1, button2, button3, button4, button5

    case caption1, caption2

    case label

    public indirect enum Custom {
        case scTextAttributes(SCTextAttributes)

        case attributes([NSAttributedString.Key: Any])
    }

    case custom(Custom)

    case patch(
        SCTypography,
        color: UIColor? = nil,
        font: UIFont? = nil,
        letterSpacing: Double? = nil,
        lineHeight: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        baselineOffset: CGFloat? = nil,
        lineBreak: NSLineBreakMode? = nil,
        underline: (NSUnderlineStyle?, UIColor?)? = nil,
        strikethrough: (NSUnderlineStyle?, UIColor?)? = nil
    )

    public func with(
        color: UIColor? = nil,
        font: UIFont? = nil,
        letterSpacing: Double? = nil,
        lineHeight: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        baselineOffset: CGFloat? = nil,
        lineBreak: NSLineBreakMode? = nil,
        underline: (NSUnderlineStyle?, UIColor?)? = nil,
        strikethrough: (NSUnderlineStyle?, UIColor?)? = nil
    ) -> Self {
        .patch(
            self,
            color: color,
            font: font,
            letterSpacing: letterSpacing,
            lineHeight: lineHeight,
            alignment: alignment,
            baselineOffset: baselineOffset,
            lineBreak: lineBreak,
            underline: underline,
            strikethrough: strikethrough
        )
    }

    fileprivate static var fontSizeScaleFactor: CGFloat = 1.01
    fileprivate static var defaultLetterSpacing: CGFloat = 0.23

    public var scTextAttributes: SCTextAttributes {
        switch self {
        case .headline1:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 32 * Self.fontSizeScaleFactor, weight: .bold),
                letterSpacing: 0.37,
                lineHeight: 48
            )

        case .headline2:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 20 * Self.fontSizeScaleFactor, weight: .bold),
                lineHeight: 30
            )

        case .headline3:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 16 * Self.fontSizeScaleFactor, weight: .bold),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 24
            )

        case .headline4:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 14 * Self.fontSizeScaleFactor, weight: .bold),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 21
            )

        case .message:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 16 * Self.fontSizeScaleFactor, weight: .semibold),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 24
            )

        case .body:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 16 * Self.fontSizeScaleFactor, weight: .medium),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 24
            )

        case .button1:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 16 * Self.fontSizeScaleFactor, weight: .medium),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 24
            )

        case .input:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 16 * Self.fontSizeScaleFactor, weight: .medium),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 24,
                baselineOffset: 3,
                lineBreak: .byTruncatingTail
            )

        case .button2:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 14 * Self.fontSizeScaleFactor, weight: .medium),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 21
            )

        case .button3:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 16 * Self.fontSizeScaleFactor, weight: .semibold),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 24
            )

        case .button4:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 14 * Self.fontSizeScaleFactor, weight: .semibold),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 21
            )

        case .button5:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 12 * Self.fontSizeScaleFactor, weight: .semibold),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 16
            )

        case .caption1:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 14 * Self.fontSizeScaleFactor, weight: .medium),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 21
            )

        case .caption2, .label:
            return SCTextAttributes(
                color: Asset.Colors.neutral50.color,
                font: .systemFont(ofSize: 12 * Self.fontSizeScaleFactor, weight: .medium),
                letterSpacing: Self.defaultLetterSpacing,
                lineHeight: 18
            )

        case .custom(.scTextAttributes(let scTextAttributes)):
            return scTextAttributes

        case .custom(.attributes(let attributes)):
            return SCTextAttributes(attributes)

        case .patch(
            let typography,
            let color,
            let font,
            let letterSpacing,
            let lineHeight,
            let alignment,
            let baselineOffset,
            let lineBreak,
            let underline,
            let strikethrough
        ):
            return typography.scTextAttributes.with(
                color: color,
                font: font,
                letterSpacing: letterSpacing,
                lineHeight: lineHeight,
                alignment: alignment,
                baselineOffset: baselineOffset,
                lineBreak: lineBreak,
                underline: underline,
                strikethrough: strikethrough
            )

        }
    }
}
