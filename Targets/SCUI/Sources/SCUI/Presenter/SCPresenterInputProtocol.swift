//
//  SCPresenterInputProtocol.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import Foundation

public protocol SCPresenterInputProtocol: AnyObject {
    func configureView()

    func showView()

    func hideView()
}
