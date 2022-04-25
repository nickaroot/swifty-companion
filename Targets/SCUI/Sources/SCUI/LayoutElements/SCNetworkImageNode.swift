//
//  SCNetworkImageNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

open class SCNetworkImageNode: ASNetworkImageNode, SCElement {
    public init() {
        super
            .init(
                cache: ASPINRemoteImageDownloader.shared(),
                downloader: ASPINRemoteImageDownloader.shared()
            )

        isLayerBacked = true
    }
}
