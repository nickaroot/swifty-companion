//
//  SCSearchComponent.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import NeedleFoundation

public final class SCSearchComponent: Component<SCSearchDependency> {
    public typealias View = SCSearchView
    public typealias ViewInput = SCSearchViewInput
    public typealias ViewOutput = SCSearchViewOutput

    public typealias Interactor = SCSearchInteractor
    public typealias InteractorInput = SCSearchInteractorInput
    public typealias InteractorOutput = SCSearchInteractorOutput

    public typealias Presenter = SCSearchPresenter<View>
    public typealias PresenterInput = SCSearchPresenterInput

    public typealias Router = SCSearchRouter
    typealias RouterInput = SCSearchRouterInput

    public typealias MainNode = SCSearchMainNode

    // MARK: - View

    public var view: View {
        View { [self] view in
            view.presenter = presenter
            view.node.delegate = presenter
            view.node.searchUsersTableNode.searchUsersDelegate = presenter
            view.node.recentUsersTableNode.recentUsersDelegate = presenter

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

    var mutableRouter: Router { shared { Router(routable: dependency.searchRoutable) } }
}
