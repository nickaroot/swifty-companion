//
//  SCSearchInteractorOutput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AuthenticationServices
import SCUI

public protocol SCSearchInteractorOutput: SCInteractorOutputProtocol,
    ASWebAuthenticationPresentationContextProviding
{}
