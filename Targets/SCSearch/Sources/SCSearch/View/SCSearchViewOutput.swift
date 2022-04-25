//
//  SCSearchViewOutput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCUI

public protocol SCSearchViewOutput: SCViewOutputProtocol {
    func didLoad()

    func willAppear(_ animated: Bool)

    func willDisappear(_ animated: Bool)
}
