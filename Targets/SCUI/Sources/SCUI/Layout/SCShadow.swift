//
//  SCShadow.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import UIKit

public struct SCShadow {
    public let color: UIColor
    public let radius: CGFloat
    public let opacity: CGFloat
    public let offset: CGSize

    public init(
        color: UIColor = .clear,
        radius: CGFloat = 0,
        opacity: CGFloat = 0,
        offset: CGSize = .zero
    ) {
        self.color = color
        self.radius = radius
        self.opacity = opacity
        self.offset = offset
    }
}
