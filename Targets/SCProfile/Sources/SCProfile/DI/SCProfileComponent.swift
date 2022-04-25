//
//  SCProfileComponent.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import NeedleFoundation

public final class SCProfileComponent: Component<SCProfileDependency> {
    public typealias View = SCProfileView
    public typealias ViewInput = SCProfileViewInput
    public typealias ViewOutput = SCProfileViewOutput

    public typealias Interactor = SCProfileInteractor
    public typealias InteractorInput = SCProfileInteractorInput
    public typealias InteractorOutput = SCProfileInteractorOutput

    public typealias Presenter = SCProfilePresenter<View>
    public typealias PresenterInput = SCProfilePresenterInput

    public typealias Router = SCProfileRouter
    typealias RouterInput = SCProfileRouterInput

    public typealias MainNode = SCProfileMainNode

    // MARK: - View

    public var view: View {
        View { [self] view in
            view.presenter = presenter
            view.node.delegate = presenter
            view.node.projectsTableNode.projectsDelegate = presenter

            mutablePresenter.view = view
            mutablePresenter.interactor = interactor
            mutablePresenter.router = router

            mutableInteractor.presenter = presenter
            mutableInteractor.api = dependency.api
        }
    }

    // MARK: - Interactor

    var interactor: Interactor { mutableInteractor }

    var mutableInteractor: Interactor { shared { Interactor() } }

    // MARK: - Presenter

    public var presenter: Presenter { mutablePresenter }

    var mutablePresenter: Presenter { shared { Presenter() } }

    // MARK: - Router

    var router: Router { mutableRouter }

    var mutableRouter: Router { shared { Router(routable: dependency.profileRoutable) } }
}
