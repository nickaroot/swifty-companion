//
//  BasicUser+Empty.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 23.04.2022.
//

import Foundation

extension BasicUser {
    public static var empty: Self {
        Self(id: .min)
    }
}
