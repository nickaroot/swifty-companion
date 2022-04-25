//
//  String+isBlank.swift
//  SCHelpers
//
//  Created by Nikita Arutyunov on 21.04.2022.
//

import Foundation

extension String {
    public var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
