//
//  SCTextAttributes+Attributes.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import UIKit

extension SCTextAttributes {
    public var attributes: [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()

        if let color = self.color { attributes[NSAttributedString.Key.foregroundColor] = color }

        if let font = self.font { attributes[NSAttributedString.Key.font] = font }

        if let letterSpacing = self.letterSpacing {
            attributes[NSAttributedString.Key.kern] = letterSpacing
        }

        let paragraphStyle = NSMutableParagraphStyle()

        if let lineHeight = self.lineHeight {
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
        }

        if let alignment = self.alignment { paragraphStyle.alignment = alignment }

        if let baselineOffset = self.baselineOffset {
            attributes[NSAttributedString.Key.baselineOffset] = baselineOffset
        }

        if let lineBreak = self.lineBreak { paragraphStyle.lineBreakMode = lineBreak }

        if let underlineStyle = underline.0 {
            attributes[NSAttributedString.Key.underlineStyle] = underlineStyle.rawValue
        }

        if let underlineColor = underline.1 {
            attributes[NSAttributedString.Key.underlineColor] = underlineColor
        }

        if let strikethroughStyle = strikethrough.0 {
            attributes[NSAttributedString.Key.strikethroughStyle] = strikethroughStyle.rawValue
        }

        if let strikethroughColor = strikethrough.1 {
            attributes[NSAttributedString.Key.strikethroughColor] = strikethroughColor
        }

        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle

        return attributes
    }

    public var typingAttributes: [String: Any] {
        Dictionary(uniqueKeysWithValues: attributes.map { ($0.key.rawValue, $0.value) })
    }

    public init(
        _ attributes: [NSAttributedString.Key: Any]
    ) {
        for attribute in attributes {
            switch attribute.key {
            case .foregroundColor: color = attribute.value as? UIColor

            case .font: font = attribute.value as? UIFont

            case .kern: letterSpacing = attribute.value as? NSNumber

            case .paragraphStyle:
                lineHeight =
                    (attribute.value as? NSParagraphStyle)?.maximumLineHeight
                    ?? (attribute.value as? NSParagraphStyle)?.minimumLineHeight
                alignment = (attribute.value as? NSParagraphStyle)?.alignment
                lineBreak = (attribute.value as? NSParagraphStyle)?.lineBreakMode
                alignment = (attribute.value as? NSParagraphStyle)?.alignment

            case .underlineStyle:
                guard let rawValue = attribute.value as? Int else { continue }

                underline.0 = NSUnderlineStyle(rawValue: rawValue)

            case .underlineColor: underline.1 = attribute.value as? UIColor

            case .strikethroughStyle:
                guard let rawValue = attribute.value as? Int else { continue }

                strikethrough.0 = NSUnderlineStyle(rawValue: rawValue)

            case .strikethroughColor: strikethrough.1 = attribute.value as? UIColor

            default: continue
            }
        }
    }
}
