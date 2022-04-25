//
//  SCProfilePresenter+SCProfileDelegate.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import SCAPI
import SCAssets
import SCUI
import UIKit

public protocol SCProfileDelegate: AnyObject {
    var basicUser: BasicUser? { get }

    var user: User? { get }

    var isProjectsEmpty: Bool { get }

    func skills(forCursus cursusID: Int) async throws -> [Skill]

    func didSelectLevel(forCursus cursusID: Int)

    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

extension SCProfilePresenter: SCProfileDelegate {
    public var isProjectsEmpty: Bool {
        projectsCount() <= 0
    }

    public func skills(forCursus cursusID: Int) async throws -> [Skill] {
        try await interactor.skills(forCursus: cursusID)
    }

    public func didSelectLevel(forCursus cursusID: Int) {
        guard
            let login = user?.login,
            let experiencesURL = Intra.Profile.experiencesURL(login, cursusID)
        else { return }

        if UIApplication.shared.canOpenURL(experiencesURL) {
            UIApplication.shared.open(experiencesURL)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleTransition(scrollView)
    }

    public func titleTransition(_ scrollView: UIScrollView) {
        let shouldTransitionTitleToNavbar: Bool = {
            let contentOffsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top

            let anchorNode = view.node.loginNode

            let anchorNodePositionY =
                view.node.scrollNode.convert(CGPoint.zero, from: anchorNode).y

            let anchorNodeHeight = anchorNode.calculatedSize.height

            let anchorNodeOffsetY = anchorNodePositionY + anchorNodeHeight

            return contentOffsetY >= anchorNodeOffsetY
        }()

        if shouldTransitionTitleToNavbar {
            guard let title = view.node.loginNode.attributedText?.string else { return }

            titleState = .navbar

            self.title = title
        } else {
            titleState = .header

            title = " "
        }
    }

    var title: String? {
        get {
            guard let textView = view.navigationItem.titleView as? UITextView else { return nil }

            return textView.attributedText.string
        }

        set(newTitle) {
            guard shouldTransitionTitleState else { return }

            shouldTransitionTitleState = false

            guard let textView = view.navigationItem.titleView as? UITextView else {
                view.navigationItem.titleView = {
                    let textView = UITextView()

                    textView.backgroundColor = .clear

                    textView.autoresizingMask = [.flexibleHeight]

                    textView.isSelectable = false
                    textView.isEditable = false

                    return textView
                }()

                return
            }

            if textView.layer.animationKeys()?.isEmpty ?? true {
                let fade = CATransition()

                fade.type = .fade
                fade.duration = 0.24

                textView.layer.add(fade, forKey: "fade")
            }

            if let newTitle = newTitle {
                textView.attributedText = NSAttributedString(
                    string: newTitle,
                    attributes: SCTextAttributes(
                        color: Asset.Colors.neutral50.color,
                        font: .systemFont(ofSize: 16, weight: .bold),
                        letterSpacing: -0.41,
                        alignment: .center,
                        lineBreak: .byTruncatingTail
                    )
                    .attributes
                )

                textView.frame = CGRect(origin: textView.frame.origin, size: textView.contentSize)
            }
        }
    }
}
