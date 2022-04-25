//
//  TargetClosure.swift
//  SCHelpers
//
//  Created by Bellisio Galvani on 21.03.2022.
//

import AsyncDisplayKit
import Foundation
import ObjectiveC

@objc class TargetClosure: NSObject {
    let closure: () -> Void

    init(
        _ closure: @escaping (() -> Void)
    ) {
        self.closure = closure

        super.init()
    }

    @objc func invoke() {
        closure()
    }
}

extension ASControlNode {
    public func addAction(for controlEvents: ASControlNodeEvent, _ closure: @escaping (() -> Void))
    {
        let targetClosure = TargetClosure(closure)

        addTarget(
            targetClosure,
            action: #selector(TargetClosure.invoke),
            forControlEvents: controlEvents
        )

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}

extension NotificationCenter {
    public func addObserver(
        name aName: NSNotification.Name?,
        object anObject: Any? = nil,
        _ closure: @escaping (() -> Void)
    ) {
        let targetClosure = TargetClosure(closure)

        addObserver(
            targetClosure,
            selector: #selector(TargetClosure.invoke),
            name: aName,
            object: anObject
        )

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}

extension UIControl {
    public func addTarget(for controlEvents: UIControl.Event, _ closure: @escaping (() -> Void)) {
        let targetClosure = TargetClosure(closure)

        addTarget(targetClosure, action: #selector(TargetClosure.invoke), for: controlEvents)

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}

extension UIGestureRecognizer {
    public convenience init(
        _ closure: @escaping (() -> Void)
    ) {
        let targetClosure = TargetClosure(closure)

        self.init(target: targetClosure, action: #selector(TargetClosure.invoke))

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}

extension UIBarButtonItem {
    public convenience init(
        image: UIImage?,
        style: UIBarButtonItem.Style,
        _ closure: @escaping (() -> Void)
    ) {
        let targetClosure = TargetClosure(closure)

        self.init(
            image: image,
            style: style,
            target: targetClosure,
            action: #selector(TargetClosure.invoke)
        )

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }

    public convenience init(
        image: UIImage?,
        landscapeImagePhone: UIImage?,
        style: UIBarButtonItem.Style,
        _ closure: @escaping (() -> Void)
    ) {
        let targetClosure = TargetClosure(closure)

        self.init(
            image: image,
            landscapeImagePhone: landscapeImagePhone,
            style: style,
            target: targetClosure,
            action: #selector(TargetClosure.invoke)
        )

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }

    public convenience init(
        title: String?,
        style: UIBarButtonItem.Style,
        _ closure: @escaping (() -> Void)
    ) {
        let targetClosure = TargetClosure(closure)

        self.init(
            title: title,
            style: style,
            target: targetClosure,
            action: #selector(TargetClosure.invoke)
        )

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }

    public convenience init(
        barButtonSystemItem systemItem: UIBarButtonItem.SystemItem,
        _ closure: @escaping (() -> Void)
    ) {
        let targetClosure = TargetClosure(closure)

        self.init(
            barButtonSystemItem: systemItem,
            target: targetClosure,
            action: #selector(targetClosure.invoke)
        )

        objc_setAssociatedObject(
            self,
            String(format: "[%d]", arc4random()),
            targetClosure,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}
