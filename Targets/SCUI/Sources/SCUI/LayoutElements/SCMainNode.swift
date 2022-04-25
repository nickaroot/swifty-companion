//
//  SCMainNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit

open class SCMainNode: SCDisplayNode {
    // MARK: - Status Bar

    open lazy var statusBarNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(
            width: .fraction(1),
            height: .auto
        )

        node.zPosition = 1000

        return node
    }()

    open var statusBarBackground: UIColor? {
        didSet {
            ASPerformBlockOnMainThread {
                UIView.animate(withDuration: 0.24) { [weak self] in
                    self?.statusBarNode.backgroundColor = self?.statusBarBackground
                }
            }

            closestViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }

    open func updateStatusBarNode() {
        statusBarNode.style.preferredLayoutSize.height = ASDimension(
            unit: .points,
            value: layoutMargins.top
        )

        statusBarNode.setNeedsLayout()
    }

    // MARK: - Keyboard

    open var keyboardNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(
            width: .fraction(1),
            height: .auto
        )

        return node
    }()

    open var keyboardFocus: (SCScrollNode, ASDisplayNode)? { didSet { scrollToFocusedNode() } }

    open func updateKeyboardNode() {
        let tabBarHeight = closestViewController?.tabBarController?.tabBar.frame.height ?? 0
        let height = SCKeyboard.isShown ? SCKeyboard.height - tabBarHeight : 0

        keyboardNode.style.preferredLayoutSize.height = .points(height)

        keyboardNode.setNeedsLayout()
        keyboardNode.layoutIfNeeded()

        setNeedsLayout()
        layoutIfNeeded()

        scrollToFocusedNode()
    }

    // MARK: - Bottom Safe Area

    open lazy var bottomSafeAreaNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(
            width: .fraction(1),
            height: .auto
        )

        return node
    }()

    open func updateBottomSafeAreaNode() {
        bottomSafeAreaNode.style.preferredLayoutSize.height = ASDimension(
            unit: .points,
            value: layoutMargins.bottom
        )

        bottomSafeAreaNode.setNeedsLayout()
    }

    override public required init() {
        super.init()

        isLayerBacked = false

        backgroundColor = .white

        insetsLayoutMarginsFromSafeArea = true
        automaticallyRelayoutOnLayoutMarginsChanges = true
        automaticallyManagesSubnodes = true
    }

    override open func layoutMarginsDidChange() {
        updateStatusBarNode()
        updateBottomSafeAreaNode()

        super.layoutMarginsDidChange()
    }

    func scrollToFocusedNode() {
        let keyboardHeight = keyboardNode.style.preferredLayoutSize.height.value

        guard keyboardHeight != 0, let (scrollNode, focusNode) = keyboardFocus else { return }

        scrollNode.scrollToVisibleNode(focusNode, animated: true)
    }
}
