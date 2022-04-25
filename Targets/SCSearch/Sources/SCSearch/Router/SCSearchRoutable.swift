//
//  SCSearchRoutable.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCAPI
import UIKit

public protocol SCSearchRoutable: AnyObject {
    func revealProfile(user: BasicUser, sender: UIViewController?)

    func revealProfile(user: User, sender: UIViewController?)
}
