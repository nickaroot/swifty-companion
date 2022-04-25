//
//  SCProfileDependency.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import NeedleFoundation
import SCAPI

public protocol SCProfileDependency: Dependency {
    var api: SCAPI { get }

    var profileRoutable: SCProfileRoutable { get }
}
