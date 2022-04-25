//
//  SCViewOutputProtocol.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import Foundation

public protocol SCViewOutputProtocol: AnyObject {
    func didLoad()

    func willAppear(_ animated: Bool)

    func willDisappear(_ animated: Bool)
}
