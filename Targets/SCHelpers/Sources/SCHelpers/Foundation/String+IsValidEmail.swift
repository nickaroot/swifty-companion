//
//  String+IsValidEmail.swift
//  SCHelpers
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

extension String {
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Za-zА-Яа-я0-9._%+-]+@[A-Za-zА-Яа-я0-9.-]+\\.[A-Za-zА-Яа-я]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailPred.evaluate(with: self)
    }
}
