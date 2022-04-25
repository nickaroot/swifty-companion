//
//  SCActionTransition.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import UIKit

public struct SCActionTransition: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let highlight = Self(rawValue: 1 << 0)
    public static let scale = Self(rawValue: 1 << 1)
    public static let haptic = Self(rawValue: 1 << 2)

    public static let all: Self = [.highlight, .scale, .haptic]

    public struct Highlight {
        public var animationDuration: TimeInterval = 0.23
        public var animationOptions: UIView.AnimationOptions = [
            .beginFromCurrentState, .allowUserInteraction,
        ]
    }

    public struct Scale { public var factor: CGFloat = 0.95 }

    public struct Haptic {
        public var minTimeout = TimeInterval(0.24)
        public var lastTime = Date()
        public var impactStyle = UIImpactFeedbackGenerator.FeedbackStyle.light

        public var isTimedOut: Bool {
            let currentTime = Date()

            let timeDelta = currentTime.timeIntervalSince(lastTime)

            return timeDelta >= minTimeout
        }

        private lazy var impactGenerator: UIImpactFeedbackGenerator = {
            UIImpactFeedbackGenerator(style: impactStyle)
        }()

        private lazy var selectionGenerator = UISelectionFeedbackGenerator()

        /// call when your UI element impacts something else with a specific intensity [0.0, 1.0]
        public mutating func impactOccured(intensity: CGFloat = 1.0, isHighlighted: Bool = true) {
            if isHighlighted { lastTime = Date() }

            impactGenerator.impactOccurred(intensity: intensity)
        }

        /// call when the selection changes (not on initial selection)
        public mutating func selectionChanged() { selectionGenerator.selectionChanged() }
    }

    public var highlight = Highlight()
    public var scale = Scale()
    public var haptic = Haptic()
}
