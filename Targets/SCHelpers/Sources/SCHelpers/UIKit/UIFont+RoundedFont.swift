//
//  UIFont+RoundedFont.swift
//
//
//  Created by Nikita Arutyunov on 24.12.2021.
//

import UIKit

extension UIFont {
    public class func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        guard #available(iOS 13.0, *),
            let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor
                .withDesign(.rounded)
        else {
            return UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        return UIFont(descriptor: descriptor, size: fontSize)
    }
}
