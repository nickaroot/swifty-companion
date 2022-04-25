//
//  SCScrollNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

open class SCScrollNode: ASScrollNode, SCElement, UIScrollViewDelegate {
    /// Strictly restraint to use on **Main Thread**
    open var automaticallyHideKeyboardOnDrag: Bool {
        get { view.keyboardDismissMode != .none }

        set { view.keyboardDismissMode = newValue ? .onDrag : .none }
    }

    override public init() {
        super.init()

        style.flexShrink = 1.0

        automaticallyManagesSubnodes = true
        automaticallyManagesContentSize = true
    }

    override open func didLoad() {
        super.didLoad()

        view.delegate = self
        view.alwaysBounceVertical = true
        view.delaysContentTouches = false

        automaticallyHideKeyboardOnDrag = true
    }

    open func scrollToVisibleNode(
        _ node: ASDisplayNode,
        offset: CGFloat? = nil,
        animated flag: Bool
    ) {
        ASPerformBlockOnMainThread { [weak self] in
            guard let self = self else { return }

            let maxOffsetY = self.view.contentSize.height - self.calculatedSize.height
            let nodeOffsetY = node.convert(.zero, to: self).y
            let initialOffsetY = -self.safeAreaInsets.top

            let offsetY = max(0, min(maxOffsetY, nodeOffsetY)) + (offset ?? 0) + initialOffsetY

            let contentOffset = CGPoint(x: 0, y: offsetY)

            self.view.setContentOffset(contentOffset, animated: flag)
        }
    }
}
