//
//  SCProfilePresenter.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import SCAPI
import SCAssets
import SCUI

public final class SCProfilePresenter<ViewInput: SCProfileComponent.ViewInput>: SCPresenterProtocol
{
    typealias Component = SCProfileComponent

    weak var view: ViewInput!

    var router: Component.RouterInput!
    var interactor: Component.InteractorInput!

    enum TitleState {
        case header, navbar
    }

    var titleState = TitleState.header {
        didSet(newTitleState) {
            guard titleState != newTitleState else { return }

            shouldTransitionTitleState = true
        }
    }

    var shouldTransitionTitleState = true

    public var basicUser: BasicUser?

    public var user: User? {
        didSet {
            guard let user = user else { return }

            view?.node.update(withUser: user)
        }
    }

    var projects: [ProjectsUser]? {
        guard
            let projects = user?.projectsUsers,
            let cursusID = view.node.selectedCursus?.id
        else { return nil }

        return Array(
            projects
                .filter({ $0.cursusIDs.contains(cursusID) && $0.project?.parentID == nil })
                .sorted(by: {
                    guard
                        let leftUpdatedAt = $0.updatedAt,
                        let rightUpdatedAt = $1.updatedAt
                    else { return false }

                    return leftUpdatedAt > rightUpdatedAt
                })
        )
    }

    public func configureView() {
        view.node.transitionLayout(withAnimation: true, shouldMeasureAsync: false)

        if let basicUser = basicUser {
            Task { [weak self] in
                guard let user = try? await interactor.getUser(id: basicUser.id) else { return }

                self?.user = user
            }
        } else if let user = user {
            view.node.update(withUser: user)

            view.node.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
        }
    }

    public func showView() {
        router.navigationController = view.navigationController
        router.tabBarController = view.tabBarController

        setupNavigationBar()
    }

    public func hideView() {}

    func setupNavigationBar() {
        view.title = " "
        view.statusBarStyle = .default
        view.modalPresentationCapturesStatusBarAppearance = true
        view.isNavigationBarShowing = true
        view.navigationBackButton = UIBarButtonItem()

        view.navigationItem.setRightBarButton(
            {
                let globeImage = UIImage(
                    systemSymbol: .globe,
                    withConfiguration: UIImage.SymbolConfiguration(weight: .medium)
                )

                let barButtonItem = UIBarButtonItem(
                    image: globeImage,
                    style: .plain,
                    { [weak self] in
                        guard
                            let login = self?.user?.login ?? self?.basicUser?.login,
                            let profileURL = Intra.Profile.userURL(login)
                        else { return }

                        if UIApplication.shared.canOpenURL(profileURL) {
                            UIApplication.shared.open(profileURL)
                        }
                    }
                )

                return barButtonItem
            }(),
            animated: false
        )

        do {
            let appearance = UINavigationBarAppearance()

            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = Asset.Colors.neutral10.color

            view.navigationItem.standardAppearance = appearance
            view.navigationItem.scrollEdgeAppearance = appearance
        }
    }
}
