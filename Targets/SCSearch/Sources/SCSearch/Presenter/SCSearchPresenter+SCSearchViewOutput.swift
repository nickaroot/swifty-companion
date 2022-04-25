//
//  SCSearchPresenter+SCSearchViewOutput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import Foundation

extension SCSearchPresenter: SCSearchViewOutput {
    public func didLoad() { configureView() }

    public func willAppear(_: Bool) { showView() }

    public func willDisappear(_: Bool) { hideView() }
}
