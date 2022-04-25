//
//  SCActionNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import TextureUI
import UIKit

open class SCActionNode: ASControlNode, SCElement {
    public typealias SCButtonActionBlock = ((SCActionNode) -> Void)

    // MARK: - Background Color

    /// - You should use this property instead of **backgroundColor**

    open var normalBackgroundColor: UIColor? {
        didSet { if !isDisabled, !isHighlighted { backgroundColor = normalBackgroundColor } }
    }

    open var disabledBackgroundColor: UIColor? {
        didSet { if isDisabled { backgroundColor = disabledBackgroundColor } }
    }

    open var highlightedBackgroundColor: UIColor? {
        didSet { if !isDisabled, isHighlighted { backgroundColor = highlightedBackgroundColor } }
    }

    // MARK: - Border

    /// - You should use this property instead of **border**

    open var normalBorder: SCBorder? {
        didSet {
            if !isDisabled, !isHighlighted, let normalBorder = normalBorder {
                border = normalBorder
            }
        }
    }

    open var disabledBorder: SCBorder? {
        didSet { if isDisabled, let disabledBorder = disabledBorder { border = disabledBorder } }
    }

    open var highlightedBorder: SCBorder? {
        didSet {
            if !isDisabled, isHighlighted, let highlightedBorder = highlightedBorder {
                border = highlightedBorder
            }
        }
    }

    // MARK: - Interface States

    open var transition: SCActionTransition = [.highlight, .haptic]

    override open var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue, !isDisabled else { return }

            if transition.contains(.scale) {
                ASPerformBlockOnMainThread { [weak self] in
                    self?.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
                }
            }

            if transition.contains(.haptic), isHighlighted || transition.haptic.isTimedOut {
                transition.haptic.impactOccured(isHighlighted: isHighlighted)
            }

            if transition.contains(.highlight) {
                if isHighlighted { setHighlightedState() } else { setNormalState() }
            }
        }
    }

    override open var isEnabled: Bool { willSet { isDisabled = !newValue } }

    /// *isEnabled* alternative that allows to interact with button through **disabled** action blocks
    open var isDisabled: Bool = false {
        willSet {
            if isDisabled != newValue {
                if newValue {
                    setDisabledState()
                } else if isHighlighted {
                    setHighlightedState()
                } else {
                    setNormalState()
                }
            }
        }
    }

    // MARK: - Init

    override public init() {
        super.init()

        automaticallyManagesSubnodes = true

        backgroundColor = normalBackgroundColor

        if let normalBorder = normalBorder { border = normalBorder }

        addActions()
    }

    // MARK: - Did Load

    override open func didLoad() { super.didLoad() }

    // MARK: - Touch Actions

    open func addActions() {
        addTarget(self, action: #selector(touchDown(_:)), forControlEvents: .touchDown)
        addTarget(self, action: #selector(touchDownRepeat(_:)), forControlEvents: .touchDownRepeat)
        addTarget(self, action: #selector(touchDragInside(_:)), forControlEvents: .touchDragInside)
        addTarget(
            self,
            action: #selector(touchDragOutside(_:)),
            forControlEvents: .touchDragOutside
        )
        addTarget(self, action: #selector(touchUpInside(_:)), forControlEvents: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutside(_:)), forControlEvents: .touchUpOutside)
        addTarget(self, action: #selector(touchCancel(_:)), forControlEvents: .touchCancel)
        addTarget(self, action: #selector(valueChanged(_:)), forControlEvents: .valueChanged)
    }

    open var touchAnimationDuration: TimeInterval { 0.23 }

    open var touchAnimationOptions: UIView.AnimationOptions {
        [.beginFromCurrentState, .allowUserInteraction]
    }

    open var touchDownBlock: SCButtonActionBlock?

    open var touchDownDisabledBlock: SCButtonActionBlock?

    @objc open func touchDown(_: ASControlNode) {
        guard !isDisabled else {
            touchDownDisabledBlock?(self)

            return
        }

        //        isHighlighted = true

        touchDownBlock?(self)
    }

    open var touchDownRepeatBlock: SCButtonActionBlock?

    open var touchDownRepeatDisabledBlock: SCButtonActionBlock?

    @objc open func touchDownRepeat(_: ASControlNode) {
        guard !isDisabled else {
            touchDownRepeatDisabledBlock?(self)

            return
        }

        //        isHighlighted = true

        touchDownRepeatBlock?(self)
    }

    open var touchDragInsideBlock: SCButtonActionBlock?

    open var touchDragInsideDisabledBlock: SCButtonActionBlock?

    @objc open func touchDragInside(_: ASControlNode) {
        guard !isDisabled else {
            touchDragInsideDisabledBlock?(self)

            return
        }

        touchDragInsideBlock?(self)
    }

    open var touchDragOutsideBlock: SCButtonActionBlock?

    open var touchDragOutsideDisabledBlock: SCButtonActionBlock?

    @objc open func touchDragOutside(_: ASControlNode) {
        guard !isDisabled else {
            touchDragOutsideDisabledBlock?(self)

            return
        }

        touchDragOutsideBlock?(self)
    }

    open var touchUpInsideBlock: SCButtonActionBlock?

    open var touchUpInsideDisabledBlock: SCButtonActionBlock?

    @objc open func touchUpInside(_: ASControlNode) {
        guard !isDisabled else {
            touchUpInsideDisabledBlock?(self)

            return
        }

        //        isHighlighted = false

        touchUpInsideBlock?(self)
    }

    open var touchUpOutsideBlock: SCButtonActionBlock?

    open var touchUpOutsideDisabledBlock: SCButtonActionBlock?

    @objc open func touchUpOutside(_: ASControlNode) {
        guard !isDisabled else {
            touchUpOutsideDisabledBlock?(self)

            return
        }

        //        isHighlighted = false

        touchUpOutsideBlock?(self)
    }

    open var touchCancelBlock: SCButtonActionBlock?

    open var touchCancelDisabledBlock: SCButtonActionBlock?

    @objc open func touchCancel(_: ASControlNode) {
        guard !isDisabled else {
            touchCancelDisabledBlock?(self)

            return
        }

        //        isHighlighted = false

        touchCancelBlock?(self)
    }

    open var valueChangedBlock: SCButtonActionBlock?

    @objc open func valueChanged(_: ASControlNode) { valueChangedBlock?(self) }

    // MARK: - Context Menu

    open var contextMenuPrimaryActionTriggeredBlock: SCButtonActionBlock?
    open var contextMenuMenuActionTriggeredBlock: SCButtonActionBlock?
    open var contextMenuTouchCancelBlock: SCButtonActionBlock?
    open var contextMenuTouchDownBlock: SCButtonActionBlock?
    open var contextMenuTouchDownRepeatBlock: SCButtonActionBlock?
    open var contextMenuTouchUpInsideBlock: SCButtonActionBlock?
    open var contextMenuTouchUpOutsideBlock: SCButtonActionBlock?
    open var contextMenuTouchDragEnterBlock: SCButtonActionBlock?
    open var contextMenuTouchDragExitBlock: SCButtonActionBlock?

    open var contextMenuIsPrimaryAction = false

    open var contextMenu: UIMenu? {
        didSet {
            if contextMenu != nil {
                contextMenuPrimaryActionTriggeredBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.haptic), self.transition.haptic.isTimedOut {
                        self.transition.haptic.impactOccured(isHighlighted: self.isHighlighted)
                    }

                    if self.transition.contains(.highlight) {
                        self.setNormalState()
                    }
                }

                contextMenuMenuActionTriggeredBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.haptic), self.transition.haptic.isTimedOut {
                        self.transition.haptic.impactOccured(isHighlighted: self.isHighlighted)
                    }

                    if self.transition.contains(.highlight) {
                        self.setNormalState()
                    }
                }

                contextMenuTouchCancelBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.highlight) {
                        self.setNormalState()
                    }

                    self.touchCancelBlock?(self)
                }

                contextMenuTouchDownBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.haptic), self.transition.haptic.isTimedOut {
                        self.transition.haptic.impactOccured(isHighlighted: self.isHighlighted)
                    }

                    if self.transition.contains(.highlight) {
                        self.setHighlightedState()
                    }

                    self.touchDownBlock?(self)
                }

                contextMenuTouchDownRepeatBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.highlight) {
                        self.setHighlightedState()
                    }

                    self.touchDownRepeatBlock?(self)
                }

                contextMenuTouchUpInsideBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.haptic), self.transition.haptic.isTimedOut {
                        self.transition.haptic.impactOccured(isHighlighted: self.isHighlighted)
                    }

                    if self.transition.contains(.highlight) {
                        self.setNormalState()
                    }

                    self.touchUpInsideBlock?(self)
                }

                contextMenuTouchUpOutsideBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.highlight) {
                        self.setNormalState()
                    }

                    self.touchUpOutsideBlock?(self)
                }

                contextMenuTouchDragEnterBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.haptic), self.transition.haptic.isTimedOut {
                        self.transition.haptic.impactOccured(isHighlighted: self.isHighlighted)
                    }

                    if self.transition.contains(.highlight) {
                        self.setHighlightedState()
                    }
                }

                contextMenuTouchDragExitBlock = { [weak self] _ in
                    guard let self = self else { return }

                    if self.transition.contains(.haptic), self.transition.haptic.isTimedOut {
                        self.transition.haptic.impactOccured(isHighlighted: self.isHighlighted)
                    }

                    if self.transition.contains(.highlight) {
                        self.setNormalState()
                    }
                }
            } else {
                contextMenuPrimaryActionTriggeredBlock = nil
                contextMenuMenuActionTriggeredBlock = nil
                contextMenuTouchCancelBlock = nil
                contextMenuTouchDownBlock = nil
                contextMenuTouchDownRepeatBlock = nil
                contextMenuTouchUpInsideBlock = nil
                contextMenuTouchUpOutsideBlock = nil
                contextMenuTouchDragEnterBlock = nil
                contextMenuTouchDragExitBlock = nil

            }

            ASPerformBlockOnMainThread { [weak self] in
                guard let self = self else { return }

                self.transitionLayout(withAnimation: true, shouldMeasureAsync: false)

                guard
                    self.isInDisplayState,
                    let contextButton = self.contextNode.view as? UIButton
                else {
                    return
                }

                contextButton.menu = self.contextMenu
                contextButton.showsMenuAsPrimaryAction = self.contextMenuIsPrimaryAction
            }
        }
    }

    open lazy var contextNode: SCDisplayNode = {
        let node = SCDisplayNode {
            UIButton()
        } didLoad: { [weak self] node in
            guard let self = self, let contextButton = node.view as? UIButton else { return }

            contextButton.addTarget(for: .primaryActionTriggered) { [weak self] in
                guard let self = self else { return }

                self.contextMenuPrimaryActionTriggeredBlock?(self)
            }

            contextButton.addTarget(for: .menuActionTriggered) { [weak self] in
                guard let self = self else { return }

                self.contextMenuMenuActionTriggeredBlock?(self)
            }

            contextButton.addTarget(for: .touchCancel) { [weak self] in
                guard let self = self else { return }

                self.contextMenuTouchCancelBlock?(self)
            }

            contextButton.addTarget(for: .touchDown) { [weak self] in
                guard let self = self else { return }

                self.contextMenuTouchDownBlock?(self)
            }

            contextButton.addTarget(for: .touchDownRepeat) { [weak self] in
                guard let self = self else { return }

                self.contextMenuTouchDownRepeatBlock?(self)
            }

            contextButton.addTarget(for: .touchUpInside) { [weak self] in
                guard let self = self else { return }

                self.contextMenuTouchUpInsideBlock?(self)
            }

            contextButton.addTarget(for: .touchUpOutside) { [weak self] in
                guard let self = self else { return }

                self.contextMenuTouchUpOutsideBlock?(self)
            }

            contextButton.addTarget(for: .touchDragEnter) { [weak self] in
                guard let self = self else { return }

                self.contextMenuTouchDragEnterBlock?(self)
            }

            contextButton.addTarget(for: .touchDragExit) { [weak self] in
                guard let self = self else { return }

                self.contextMenuTouchDragExitBlock?(self)
            }

            contextButton.menu = self.contextMenu
            contextButton.showsMenuAsPrimaryAction = self.contextMenuIsPrimaryAction
        }

        return node
    }()

    // MARK: - Transition

    override open func animateLayoutTransition(_ context: ASContextTransitioning) {
        if context.isAnimated() {
            if transition.contains(.scale) {
                let scale = isHighlighted ? transition.scale.factor : 1

                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
                }
            }
        } else {
            super.animateLayoutTransition(context)
        }
    }
}

extension SCActionNode {
    fileprivate func setNormalState() {
        if let normalBackgroundColor = normalBackgroundColor {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.backgroundColor = normalBackgroundColor }
            )
        }

        if let normalBorder = normalBorder {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.border = normalBorder }
            )
        }
    }

    fileprivate func setHighlightedState() {
        if let highlightedBackgroundColor = highlightedBackgroundColor
            ?? normalBackgroundColor?.highlighted
        {
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.backgroundColor = highlightedBackgroundColor }
            )
        }

        if let highlightedBorder = highlightedBorder ?? normalBorder?.highlighted {
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.border = highlightedBorder }
            )
        }
    }

    fileprivate func setDisabledState() {
        if let disabledBackgroundColor = disabledBackgroundColor ?? normalBackgroundColor?.disabled
        {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.backgroundColor = disabledBackgroundColor }
            )
        }

        if let disabledBorder = disabledBorder ?? normalBorder?.disabled {
            UIView.animate(
                withDuration: touchAnimationDuration,
                delay: 0,
                options: touchAnimationOptions,
                animations: { [weak self] in self?.border = disabledBorder }
            )
        }
    }
}
