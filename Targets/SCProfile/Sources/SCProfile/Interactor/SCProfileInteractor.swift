//
//  SCProfileInteractor.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCAPI
import SCUI

public final class SCProfileInteractor: SCInteractorProtocol {
    typealias Component = SCProfileComponent

    weak var presenter: Component.InteractorOutput!

    weak var api: SCAPI!
}
