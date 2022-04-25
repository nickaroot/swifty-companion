//
//  SCProfileView.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import SCUI

public final class SCProfileView: ASDKViewController<SCProfileComponent.MainNode>, SCViewProtocol {
    public typealias Component = SCProfileComponent

    public var presenter: Component.ViewOutput!

    public var statusBarStyle: UIStatusBarStyle = .default {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle { return statusBarStyle }

    let onDidLoad: ((SCProfileView) -> Void)?

    public init(
        _ onDidLoad: ((SCProfileView) -> Void)? = nil
    ) {
        self.onDidLoad = onDidLoad

        super.init(node: MainNode())
    }

    @available(*, unavailable) required init?(
        coder _: NSCoder
    ) { fatalError("init(coder:) not implemented") }

    override public func viewDidLoad() {
        super.viewDidLoad()

        onDidLoad?(self)

        presenter.didLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.willAppear(animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.willDisappear(animated)
    }
}
