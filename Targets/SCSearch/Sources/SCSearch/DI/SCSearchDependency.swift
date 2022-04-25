//
//  SCSearchDependency.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import NeedleFoundation
import SCAPI

public protocol SCSearchDependency: Dependency {
    var api: SCAPI { get }

    var searchRoutable: SCSearchRoutable { get }
}
