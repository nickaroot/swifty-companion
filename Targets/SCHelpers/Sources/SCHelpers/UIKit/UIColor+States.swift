//
//  UIColor+States.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import SCAssets
import UIKit

extension UIColor {
    open var highlighted: UIColor {
        guard let hue = hue, let saturation = saturation, var brightness = brightness,
            let alpha = alpha
        else { return self }

        let factor = CGFloat(0.098)

        brightness -= brightness > 0.5 ? factor : -factor

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    open var textHighlighted: UIColor {
        guard let alpha = alpha else { return self }

        return self.withAlphaComponent(alpha - 0.8)
    }

    open var disabled: UIColor {
        //        guard let brightness = brightness,
        //            let alpha = alpha else { return self }
        //
        //        return UIColor(hue: 0, saturation: 0, brightness: brightness, alpha: alpha)

        return Asset.Colors.neutral10.color
    }

    open var textDisabled: UIColor { return Asset.Colors.neutral40.color }
}
