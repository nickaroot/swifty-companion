//
//  UIColor+HSB.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import UIKit

extension UIColor {
    open var hue: CGFloat? {
        var value = CGFloat.leastNonzeroMagnitude

        getHue(&value, saturation: nil, brightness: nil, alpha: nil)

        return value != CGFloat.leastNonzeroMagnitude ? value : nil
    }

    open var saturation: CGFloat? {
        var value = CGFloat.leastNonzeroMagnitude

        getHue(nil, saturation: &value, brightness: nil, alpha: nil)

        return value != CGFloat.leastNonzeroMagnitude ? value : nil
    }

    open var brightness: CGFloat? {
        var value = CGFloat.leastNonzeroMagnitude

        getHue(nil, saturation: nil, brightness: &value, alpha: nil)

        return value != CGFloat.leastNonzeroMagnitude ? value : nil
    }

    open var alpha: CGFloat? {
        var value = CGFloat.leastNonzeroMagnitude

        getHue(nil, saturation: nil, brightness: nil, alpha: &value)

        return value != CGFloat.leastNonzeroMagnitude ? value : nil
    }
}
