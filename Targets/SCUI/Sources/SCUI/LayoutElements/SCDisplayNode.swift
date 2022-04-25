//
//  SCDisplayNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

open class SCDisplayNode: ASDisplayNode, SCElement {
    override public init() {
        super.init()

        isLayerBacked = true

        automaticallyManagesSubnodes = true
    }

    public convenience init(
        viewBlock: @escaping ASDisplayNodeViewBlock,
        didLoad didLoadBlock: ASDisplayNodeDidLoadBlock? = nil
    ) {
        self.init()

        isLayerBacked = false

        setViewBlock(viewBlock)

        guard let didLoadBlock = didLoadBlock else { return }

        onDidLoad(didLoadBlock)
    }

    public convenience init(
        layerBlock: @escaping ASDisplayNodeLayerBlock,
        didLoad didLoadBlock: ASDisplayNodeDidLoadBlock? = nil
    ) {
        self.init()

        isLayerBacked = true

        setLayerBlock(layerBlock)

        guard let didLoadBlock = didLoadBlock else { return }

        onDidLoad(didLoadBlock)
    }

    override open func didLoad() { super.didLoad() }
}
