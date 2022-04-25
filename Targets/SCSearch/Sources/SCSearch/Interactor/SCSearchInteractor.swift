//
//  SCSearchInteractor.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCAPI
import SCUI

public final class SCSearchInteractor: SCInteractorProtocol {
    typealias Component = SCSearchComponent

    weak var presenter: Component.InteractorOutput!

    weak var api: SCAPI!
}
