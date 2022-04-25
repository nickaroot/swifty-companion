//
//  SCSearchPresenterInput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCUI

public protocol SCSearchPresenterInput: SCPresenterInputProtocol {
    func configureView()

    func showView()

    func hideView()
}

extension SCSearchPresenter: SCSearchPresenterInput {}
