//
//  File.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

public func animatedImage(with data: Data) -> ASAnimatedImageProtocol? {
    ASPINRemoteImageDownloader().animatedImage(with: data)
}
