//
//  SCTextAttributes.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import UIKit

public struct SCTextAttributes {
    public var color: UIColor?
    public var font: UIFont?
    public var letterSpacing: NSNumber?
    public var lineHeight: CGFloat?
    public var alignment: NSTextAlignment?
    public var baselineOffset: CGFloat?
    public var lineBreak: NSLineBreakMode?
    public var underline: (NSUnderlineStyle?, UIColor?) = (nil, nil)
    public var strikethrough: (NSUnderlineStyle?, UIColor?) = (nil, nil)

    public init(
        color: UIColor?,
        font: UIFont?,
        letterSpacing: Double? = nil,
        lineHeight: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        baselineOffset: CGFloat? = nil,
        lineBreak: NSLineBreakMode? = nil,
        underline: (NSUnderlineStyle?, UIColor?) = (nil, nil),
        strikethrough: (NSUnderlineStyle?, UIColor?) = (nil, nil)
    ) {
        self.color = color
        self.font = font

        if let letterSpacing = letterSpacing {
            self.letterSpacing = NSNumber(floatLiteral: letterSpacing)
        }

        self.lineHeight = lineHeight
        self.alignment = alignment
        self.baselineOffset = baselineOffset
        self.lineBreak = lineBreak
        self.underline = underline
        self.strikethrough = strikethrough
    }

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
        var newAttributes = self

        if let color = color { newAttributes.color = color }

        if let font = font { newAttributes.font = font }

        if let letterSpacing = letterSpacing {
            newAttributes.letterSpacing = NSNumber(floatLiteral: letterSpacing)
        }

        if let lineHeight = lineHeight { newAttributes.lineHeight = lineHeight }

        if let alignment = alignment { newAttributes.alignment = alignment }

        if let baselineOffset = baselineOffset { newAttributes.baselineOffset = baselineOffset }

        if let lineBreak = lineBreak { newAttributes.lineBreak = lineBreak }

        if let underline = underline { newAttributes.underline = underline }

        if let strikethrough = strikethrough { newAttributes.strikethrough = strikethrough }

        return newAttributes
    }
}
