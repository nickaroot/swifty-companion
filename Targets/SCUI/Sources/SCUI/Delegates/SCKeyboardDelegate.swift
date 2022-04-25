//
//  SCKeyboardDelegate.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

public protocol SCKeyboardDelegate: AnyObject {
    associatedtype ViewInput: SCViewInputProtocol

    var view: ViewInput! { get }

    var keyboardObserver: (NSObjectProtocol, NSObjectProtocol)? { get set }

    func keyboardDidChange()
}

extension SCKeyboardDelegate {
    public func keyboardSubscribe() {
        guard view != nil else { return }

        keyboardObserver = SCKeyboard.subscribe(
            willShow: keyboardWillShow(notification:),
            willHide: keyboardWillHide(notification:)
        )
    }

    public func keyboardUnsubscribe() { SCKeyboard.unsubscribe(keyboardObserver) }

    public func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        guard
            let animationTime =
                (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject)
                .doubleValue
        else { return }

        guard
            let height =
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                .cgRectValue.height
        else { return }

        SCKeyboard.isShown = true
        SCKeyboard.animationTime = animationTime
        SCKeyboard.height = height

        keyboardDidChange()
    }

    public func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        guard
            let animationTime =
                (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject)
                .doubleValue
        else { return }

        guard
            let height =
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                .cgRectValue.height
        else { return }

        SCKeyboard.isShown = false
        SCKeyboard.animationTime = animationTime
        SCKeyboard.height = height

        keyboardDidChange()
    }

    public func keyboardDidChange() {
        guard view != nil else { return }

        view.node.updateKeyboardNode()
    }
}

open class SCKeyboard: UIResponder {
    public static var isShown = false

    public static var animationTime = Double(0)
    public static var height = CGFloat(0)

    public static func subscribe(
        willShow: @escaping (Notification) -> Void,
        willHide: @escaping (Notification) -> Void
    ) -> (NSObjectProtocol, NSObjectProtocol)? {
        let willShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: willShow
        )

        let willHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: willHide
        )

        return (willShowObserver, willHideObserver)
    }

    public static func unsubscribe(_ observer: (NSObjectProtocol, NSObjectProtocol)?) {
        guard let observer = observer else { return }

        NotificationCenter.default.removeObserver(observer.0)
        NotificationCenter.default.removeObserver(observer.1)
    }
}
