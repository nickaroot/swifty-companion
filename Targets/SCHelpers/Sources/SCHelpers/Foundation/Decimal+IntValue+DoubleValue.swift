//
//  Decimal+IntValue+DoubleValue.swift
//  SCHelpers
//
//  Created by Nikita Arutyunov on 12.04.2022.
//

import Foundation

extension Decimal {
    public var doubleValue: Double {
        Double(description) ?? 0
    }

    public var intValue: Int {
        Int(doubleValue)
    }

    public func description(with precision: Int, _ rule: FloatingPointRoundingRule? = nil) -> String
    {
        let doubleValue: Double = {
            if let rule = rule {
                return self.doubleValue.rounded(rule)
            } else {
                return self.doubleValue
            }
        }()

        return String(format: "%.\(precision)f", doubleValue)
    }
}
