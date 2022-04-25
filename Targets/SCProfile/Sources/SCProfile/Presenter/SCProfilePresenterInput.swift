//
//  SCProfilePresenterInput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCUI

public protocol SCProfilePresenterInput: SCPresenterInputProtocol {
    func configureView()

    func showView()

    func hideView()
}

extension SCProfilePresenter: SCProfilePresenterInput {}
