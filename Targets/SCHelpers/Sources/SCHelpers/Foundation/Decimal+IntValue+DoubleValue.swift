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
            guard let rule = rule else {
                return self.doubleValue
            }
            return self.doubleValue.rounded(rule)
        }()

        return String(format: "%.\(precision)f", doubleValue)
    }
}
