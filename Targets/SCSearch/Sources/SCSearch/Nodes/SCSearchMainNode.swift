//
//  SCSearchMainNode.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import SCAssets
import SCUI
import SFSafeSymbols
import TextureUI
import UIKit

public final class SCSearchMainNode: SCMainNode {
    typealias Component = SCSearchComponent

    weak var delegate: SCSearchDelegate?

    // MARK: - Search

    lazy var searchBarNode: SCDisplayNode = {
        let node = SCDisplayNode {
            UISearchBar()
        } didLoad: { node in
            guard let searchBar = node.view as? UISearchBar else { return }

            searchBar.placeholder = "Enter login or name"
            searchBar.backgroundImage = nil
            searchBar.backgroundColor = .clear
            searchBar.searchBarStyle = .minimal
            searchBar.tintColor = Asset.Colors.tiffany50.color

            searchBar.autocapitalizationType = .none
            searchBar.autocorrectionType = .no

            searchBar.delegate = self
        }

        return node
    }()

    // MARK: - Initial

    lazy var initialIconNode: SCImageNode = {
        let node = SCImageNode()

        node.tintColor = Asset.Colors.neutral10.color

        node.image = UIImage(
            systemSymbol: .checkmarkSeal,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 144, weight: .regular)
        )

        return node
    }()

    lazy var initialTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .headline3)

        node.tintColor = Asset.Colors.neutral50.color

        node.text = """
            You're awesome!
            """

        return node
    }()

    lazy var initialSubtitleNode: SCTextNode = {
        let node = SCTextNode(typography: .body.with(alignment: .center))

        node.tintColor = Asset.Colors.neutral50.color

        node.text = """
            Now, you can search for the
            People of Intergalactic 42 Community
            """

        return node
    }()

    lazy var initialSearchNode: SCButtonNode = {
        let node = SCButtonNode(
            buttonStyle: .tinted,
            size: .s
        )

        node.typography = node.typography.with(baselineOffset: -0.5)

        node.normalText = "Let's Search"

        node.customTitleLeftNode = {
            let node = SCImageNode()

            node.tintColor = Asset.Colors.neutral0.color

            node.image = UIImage(
                systemSymbol: .magnifyingglassCircleFill,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 21,
                    weight: .medium
                )
            )
            .withRenderingMode(.alwaysTemplate)

            return node
        }()

        node.customTitleNodesSpacing = (left: 7, right: 0)

        node.horizontalPadding = 16

        node.touchUpInsideBlock = { [weak self] _ in
            self?.searchBarNode.view.becomeFirstResponder()
        }

        return node
    }()

    lazy var initialProfileNode: SCButtonNode = {
        let node = SCButtonNode(
            buttonStyle: .outlined,
            size: .s
        )

        node.typography = node.typography.with(baselineOffset: -0.5)

        node.normalText = "My Profile"

        node.customTitleLeftNode = {
            let node = SCImageNode()

            node.tintColor = Asset.Colors.neutral50.color

            node.image = UIImage(
                systemSymbol: .personFill,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 14,
                    weight: .medium
                )
            )
            .withRenderingMode(.alwaysTemplate)

            return node
        }()

        node.customTitleNodesSpacing = (left: 7, right: 0)

        node.horizontalPadding = 16

        node.isLoading = true

        node.touchUpInsideBlock = { [weak self] _ in
            self?.delegate?.didTapProfile()
        }

        return node
    }()

    // MARK: - Recent Users

    lazy var recentUsersTableNode: RecentUsersTableNode = {
        let layoutDelegate = ASCollectionFlowLayoutDelegate(scrollableDirections: [.up, .down])

        let node = RecentUsersTableNode(layoutDelegate: layoutDelegate)

        node.delegate = node
        node.dataSource = node

        node.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

        node.backgroundColor = Asset.Colors.neutral0.color

        return node
    }()

    // MARK: - Search Users

    lazy var searchUsersTableNode: SearchUsersTableNode = {
        let layoutDelegate = ASCollectionFlowLayoutDelegate(scrollableDirections: [.up, .down])

        let node = SearchUsersTableNode(layoutDelegate: layoutDelegate)

        node.delegate = node
        node.dataSource = node

        node.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

        node.backgroundColor = Asset.Colors.neutral0.color

        return node
    }()

    // MARK: - Empty

    lazy var emptyIconNode: SCImageNode = {
        let node = SCImageNode()

        node.tintColor = Asset.Colors.neutral10.color

        node.image = UIImage(
            systemSymbol: .dropTriangle,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 144, weight: .regular)
        )

        return node
    }()

    lazy var emptyTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .headline3)

        node.tintColor = Asset.Colors.neutral50.color

        node.text = """
            No Results :(
            """

        return node
    }()

    lazy var emptySubtitleNode: SCTextNode = {
        let node = SCTextNode(typography: .body.with(alignment: .center))

        node.tintColor = Asset.Colors.neutral50.color

        node.text = """
            This login or name not found
            Try another login or name
            """

        return node
    }()

    lazy var emptyButtonNode: SCButtonNode = {
        let node = SCButtonNode(
            buttonStyle: .tinted,
            size: .s
        )

        node.typography = node.typography.with(baselineOffset: -0.5)

        node.normalText = "Try another"

        node.customTitleLeftNode = {
            let node = SCImageNode()

            node.tintColor = Asset.Colors.neutral0.color

            node.image = UIImage(
                systemSymbol: .magnifyingglassCircleFill,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 21,
                    weight: .medium
                )
            )
            .withRenderingMode(.alwaysTemplate)

            return node
        }()

        node.customTitleNodesSpacing = (left: 7, right: 0)

        node.horizontalPadding = 16

        node.touchUpInsideBlock = { [weak self] _ in
            self?.searchBarNode.view.becomeFirstResponder()

            (self?.searchBarNode.node as? UISearchBar)?.selectAll(nil)
        }

        return node
    }()

    // MARK: - Auth

    lazy var authIconNode: SCImageNode = {
        let node = SCImageNode()

        node.tintColor = Asset.Colors.neutral10.color

        node.image = UIImage(
            systemSymbol: .heart,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 144, weight: .regular)
        )

        return node
    }()

    lazy var authTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .headline3)

        node.tintColor = Asset.Colors.neutral50.color

        node.text = """
            Almost there
            """

        return node
    }()

    lazy var authSubtitleNode: SCTextNode = {
        let node = SCTextNode(typography: .body.with(alignment: .center))

        node.tintColor = Asset.Colors.neutral50.color

        node.text = """
            Please, grant access to our app
            We need it because of using 42.fr API
            """

        return node
    }()

    lazy var authButtonNode: SCButtonNode = {
        let node = SCButtonNode(
            buttonStyle: .tinted,
            size: .s
        )

        node.typography = node.typography.with(baselineOffset: -0.5)

        node.normalText = "Authenticate"

        node.customTitleLeftNode = {
            let node = SCImageNode()

            node.tintColor = Asset.Colors.neutral0.color

            node.image = UIImage(
                systemSymbol: .lockCircleFill,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 21,
                    weight: .medium
                )
            )
            .withRenderingMode(.alwaysTemplate)

            return node
        }()

        node.customTitleNodesSpacing = (left: 7, right: 0)

        node.horizontalPadding = 16

        node.touchUpInsideBlock = { [weak self] _ in
            self?.delegate?.auth()
        }

        return node
    }()

    // MARK: - Did Load

    public override func didLoad() {
        super.didLoad()

        backgroundColor = Asset.Colors.neutral0.color

        statusBarBackground = Asset.Colors.neutral0.color
    }

    // MARK: - Layout Specs

    var authLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack(
                spacing: 32,
                justifyContent: .center,
                alignItems: .center,
                alignContent: .center,
                isConcurrent: true
            ) {
                authIconNode

                VStack(spacing: 24, alignItems: .center) {
                    VStack(spacing: 4, alignItems: .center) {
                        authTitleNode
                        authSubtitleNode
                    }

                    HStack {
                        authButtonNode
                    }
                }
            }
            .padding(.horizontal, 20)
            .relativePosition(horizontal: .center, vertical: .center)
        }
    }

    var initialLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                HStack(spacing: 6, isConcurrent: true) {
                    searchBarNode
                        .preferredLayoutHeight(36)
                        .flexGrow(1)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)

                VStack(
                    spacing: 32,
                    justifyContent: .center,
                    alignItems: .center,
                    alignContent: .center,
                    isConcurrent: true
                ) {
                    initialIconNode

                    VStack(spacing: 24, alignItems: .center) {
                        VStack(spacing: 4, alignItems: .center) {
                            initialTitleNode
                            initialSubtitleNode
                        }

                        HStack {
                            VStack(spacing: 12, alignItems: .stretch) {
                                initialProfileNode

                                initialSearchNode
                            }
                        }
                    }
                }
                .padding(.top, 64)
                .padding(.horizontal, 20)

                keyboardNode
            }
            .padding(.top, safeAreaInsets.top)
        }
    }

    var recentLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                HStack(spacing: 6, isConcurrent: true) {
                    searchBarNode
                        .preferredLayoutHeight(36)
                        .flexGrow(1)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)

                recentUsersTableNode
                    .flexGrow(1)

                keyboardNode
            }
            .padding(.top, safeAreaInsets.top)
        }
    }

    var searchLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                HStack(spacing: 6, isConcurrent: true) {
                    searchBarNode
                        .preferredLayoutHeight(36)
                        .flexGrow(1)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)

                searchUsersTableNode
                    .flexGrow(1)

                keyboardNode
            }
            .padding(.top, safeAreaInsets.top)
        }
    }

    var emptyLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                HStack(spacing: 6, isConcurrent: true) {
                    searchBarNode
                        .preferredLayoutHeight(36)
                        .flexGrow(1)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)

                VStack(
                    spacing: 32,
                    justifyContent: .center,
                    alignItems: .center,
                    alignContent: .center,
                    isConcurrent: true
                ) {
                    emptyIconNode

                    VStack(spacing: 24, alignItems: .center) {
                        VStack(spacing: 4, alignItems: .center) {
                            emptyTitleNode
                            emptySubtitleNode
                        }

                        HStack {
                            emptyButtonNode
                        }
                    }
                }
                .padding(.top, 128)
                .padding(.horizontal, 20)

                keyboardNode
            }
            .padding(.top, safeAreaInsets.top)
        }
    }

    override public func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
        guard let layoutState = self.delegate?.layoutState else { return ASLayoutSpec() }

        switch layoutState {

        case .auth:
            return authLayoutSpec

        case .initial:
            return initialLayoutSpec

        case .recent:
            return recentLayoutSpec

        case .search:
            return searchLayoutSpec

        case .empty:
            return emptyLayoutSpec

        }
    }
}
