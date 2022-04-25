//
//  SCProfileMainNode.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AsyncDisplayKit
import PhoneNumberKit
import SCAPI
import SCAssets
import SCUI
import SFSafeSymbols
import TextureUI
import UIKit

public final class SCProfileMainNode: SCMainNode {
    typealias Component = SCProfileComponent

    weak var delegate: SCProfileDelegate!

    // MARK: - Gradient

    lazy var gradientNode: GradientDrawingNode = {
        let node = GradientDrawingNode(
            descriptor: LinearGradientDescriptor(
                source: GradientSource(colors: [
                    GradientColor(color: Asset.Colors.neutral10.color, location: 0),
                    GradientColor(color: Asset.Colors.neutral0.color, location: 0.45),
                    GradientColor(color: Asset.Colors.neutral0.color, location: 1),
                ]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: 0, y: 1)
            )
        )

        node.border = SCBorder(radius: 8, corners: .allBottom)

        node.clipsToBounds = true

        return node
    }()

    // MARK: - Avatar

    func constructAvatarNode() -> SCAvatarNode {
        let letters = [
            delegate.user?.firstName ?? delegate.basicUser?.firstName,
            delegate.user?.lastName, delegate.basicUser?.lastName,
        ]
        .compactMap { name -> String? in
            guard let firstLetter = name?.first else {
                return nil
            }

            return String(firstLetter).capitalized
        }

        let avatarURL: URL? = {
            guard
                let avatar = delegate.user?.imageURL ?? delegate.basicUser?.imageURL
            else {
                return nil
            }

            return URL(string: avatar)
        }()

        let isOnline = (delegate.user?.location ?? delegate.basicUser?.location) != nil

        let node = SCAvatarNode(
            size: .xxl,
            letters: letters,
            url: avatarURL,
            isOnline: isOnline
        )

        return node
    }

    lazy var avatarNode: SCAvatarNode = constructAvatarNode()

    // MARK: - Name

    lazy var nameNode: SCTextNode = {
        let node = SCTextNode(typography: .headline2)

        node.text = delegate.user?.displayName ?? delegate.basicUser?.displayName

        return node
    }()

    // MARK: - Login

    lazy var loginNode: SCTextNode = {
        let node = SCTextNode(typography: .caption1)

        node.tintColor = Asset.Colors.neutral40.color

        node.text = delegate.user?.login ?? delegate.basicUser?.login

        return node
    }()

    // MARK: - Stats

    typealias Stat = (valueNode: SCTextNode, titleNode: SCTextNode, layoutSpec: ASLayoutSpec)

    func stat(value: String, title: String) -> Stat {
        let valueNode = SCTextNode(typography: .headline2)

        valueNode.text = value

        let titleNode = SCTextNode(typography: .caption1)

        titleNode.tintColor = Asset.Colors.neutral40.color

        titleNode.text = title

        let layoutSpec = LayoutSpec {
            VStack(alignItems: .center) {
                valueNode
                titleNode
            }
        }

        return (valueNode: valueNode, titleNode: titleNode, layoutSpec)
    }

    func statSeparator() -> SCDisplayNode {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(width: 1, height: .fraction(1))

        node.backgroundColor = Asset.Colors.neutral30.color

        return node
    }

    lazy var stats = (
        Wallet: stat(
            value: {
                guard
                    let wallet = delegate.user?.wallet ?? delegate.basicUser?.wallet
                else {
                    return "—"
                }

                return "\(wallet) ₳"
            }(),
            title: "Wallet"
        ),
        Location: stat(
            value: {
                guard
                    let location = delegate.user?.location ?? delegate.basicUser?.location
                else {
                    return "—"
                }

                return location
            }(),
            title: {
                guard
                    let location = delegate.user?.location ?? delegate.basicUser?.location
                else {
                    return "Unavailable"
                }

                return "Available"
            }()
        ),
        Points: stat(
            value: {
                guard
                    let correctionPoint = delegate.user?.correctionPoint
                        ?? delegate.basicUser?.correctionPoint
                else {
                    return "—"
                }

                return "\(correctionPoint)"
            }(),
            title: "Points"
        ),
        Separators: (statSeparator(), statSeparator())
    )

    // MARK: - Level

    lazy var levelNode: SCProfileLevelNode = {
        let node = SCProfileLevelNode()

        node.backgroundColor = Asset.Colors.neutral20.color

        node.border = SCBorder(radius: 8)

        node.clipsToBounds = true

        node.touchUpInsideBlock = { [weak self] _ in
            guard let cursusID = self?.selectedCursus?.id else { return }

            self?.delegate.didSelectLevel(forCursus: cursusID)
        }

        return node
    }()

    // MARK: - Cursus

    var selectedCursus: BasicCursus? {
        didSet {
            guard let selectedCursus = selectedCursus else {
                return
            }

            cursusActionTitleNode.text = selectedCursus.name
        }
    }

    lazy var cursusTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .caption1)

        node.tintColor = Asset.Colors.neutral40.color

        node.text = "Cursus".uppercased()

        return node
    }()

    var cursusMenu: UIMenu? {
        didSet {
            ASPerformBlockOnMainThread { [weak self] in
                guard let cursusMenu = self?.cursusMenu else { return }

                self?.cursusActionNode.contextMenu = cursusMenu
            }
        }
    }

    lazy var cursusActionNode: SCActionNode = {
        let node = SCActionNode()

        node.normalBackgroundColor = Asset.Colors.neutral0.color
        node.normalBorder = SCBorder(radius: 8)

        node.layoutSpecBlock = { [unowned self] _, _ in cursusLayoutSpec }

        node.contextMenu = cursusMenu
        node.contextMenuIsPrimaryAction = true

        return node
    }()

    lazy var cursusActionTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .body)

        node.text = "No cursus"

        return node
    }()

    lazy var cursusActionChevronNode: SCImageNode = {
        let node = SCImageNode()

        node.tintColor = Asset.Colors.neutral40.color

        node.image = UIImage(
            systemSymbol: .chevronDown,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        )

        return node
    }()

    // MARK: - Contacts

    lazy var contactsNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.isLayerBacked = false

        node.backgroundColor = Asset.Colors.neutral0.color
        node.border = SCBorder(radius: 8)

        node.layoutSpecBlock = { [unowned self] _, _ in contactsLayoutSpec }

        return node
    }()

    lazy var contactsSeparatorNode: SCDisplayNode = {
        let node = SCDisplayNode()

        node.style.preferredLayoutSize = ASLayoutSize(width: .auto, height: 1)

        node.backgroundColor = Asset.Colors.neutral20.color

        return node
    }()

    // MARK: - Contacts — Phone

    lazy var phoneNode: SCActionNode = {
        let node = SCActionNode()

        node.normalBackgroundColor = Asset.Colors.neutral0.color
        node.normalBorder = SCBorder(radius: 8, corners: .allTop)

        node.layoutSpecBlock = { [unowned self] _, _ in phoneLayoutSpec }

        node.touchUpInsideBlock = { [weak self] _ in
            guard
                let phoneValueText = self?.phoneValueNode.text,
                let phoneNumber = try? PhoneNumberKit().parse(phoneValueText),
                let phoneNumberURL = phoneNumber.url
            else { return }

            if UIApplication.shared.canOpenURL(phoneNumberURL) {
                UIApplication.shared.open(phoneNumberURL)
            }
        }

        return node
    }()

    lazy var phoneTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .caption2)

        node.text = "phone"

        return node
    }()

    lazy var phoneValueNode: SCTextNode = {
        let node = SCTextNode(typography: .body)

        node.tintColor = Asset.Colors.neutral40.color

        if let phone = delegate.user?.phone ?? delegate.basicUser?.phone {
            if PhoneNumberKit().isValidPhoneNumber(phone) {
                node.tintColor = Asset.Colors.tiffany50.color
            }

            node.text = phone
        } else {
            node.text = "—"
        }

        return node
    }()

    // MARK: - Contacts — Email

    lazy var emailNode: SCActionNode = {
        let node = SCActionNode()

        node.normalBackgroundColor = Asset.Colors.neutral0.color
        node.normalBorder = SCBorder(radius: 8, corners: .allBottom)

        node.layoutSpecBlock = { [unowned self] _, _ in emailLayoutSpec }

        node.touchUpInsideBlock = { [weak self] _ in
            guard
                let email = self?.emailValueNode.text,
                email.isValidEmail,
                let mailtoURL = URL(string: "mailto:\(email)")
            else { return }

            if UIApplication.shared.canOpenURL(mailtoURL) {
                UIApplication.shared.open(mailtoURL)
            }
        }

        return node
    }()

    lazy var emailTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .caption2)

        node.text = "mail"

        return node
    }()

    lazy var emailValueNode: SCTextNode = {
        let node = SCTextNode(typography: .body)

        node.tintColor = Asset.Colors.neutral40.color

        if let email = delegate.user?.email ?? delegate.basicUser?.email {
            if email.isValidEmail {
                node.tintColor = Asset.Colors.tiffany50.color
            }

            node.text = email
        } else {
            node.text = "—"
        }

        return node
    }()

    // MARK: - Projects

    lazy var projectsTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .caption1)

        node.tintColor = Asset.Colors.neutral40.color

        node.text = "Projects".uppercased()

        return node
    }()

    lazy var projectsTableNode: ProjectsTableNode = {
        let layoutDelegate = ASCollectionFlowLayoutDelegate(scrollableDirections: [.up, .down])

        let node = ProjectsTableNode(layoutDelegate: layoutDelegate)

        node.delegate = node
        node.dataSource = node

        node.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        node.border = SCBorder(radius: 8)

        node.clipsToBounds = true

        node.automaticallyManagesHeightToFitContent = true

        return node
    }()

    // MARK: - Skills

    lazy var skillsTitleNode: SCTextNode = {
        let node = SCTextNode(typography: .caption1)

        node.tintColor = Asset.Colors.neutral40.color

        node.text = "Skills".uppercased()

        return node
    }()

    var skills: [(String, CGFloat)]? {
        didSet {
            skillsNode = constructSkillsNode()

            ASPerformBlockOnMainThread { [weak self] in
                self?.scrollNode.transitionLayout(withAnimation: true, shouldMeasureAsync: false)
            }
        }
    }

    func constructSkillsNode() -> SCSkillsNode {
        let node = SCSkillsNode(skills: skills?.reversed() ?? [])

        node.backgroundColor = Asset.Colors.neutral0.color
        node.border = SCBorder(radius: 8)

        return node
    }

    lazy var skillsNode: SCSkillsNode = constructSkillsNode()

    // MARK: - Scroll

    lazy var scrollNode: SCScrollNode = {
        let node = SCScrollNode()

        node.onDidLoad { [weak self] node in
            guard let scrollNode = node as? SCScrollNode else { return }

            scrollNode.view.delegate = self

            scrollNode.view.insetsLayoutMarginsFromSafeArea = true
        }

        node.layoutSpecBlock = { [unowned self] _, _ in scrollLayoutSpec }

        return node
    }()

    // MARK: - Did Load

    public override func didLoad() {
        super.didLoad()

        backgroundColor = Asset.Colors.neutral10.color

        statusBarBackground = Asset.Colors.neutral10.color
    }

    // MARK: - Update

    func update(withUser user: User) {
        updateInfo(withUser: user)
        updateStats(withUser: user)
        updateContacts(withUser: user)
        updateCursus(withUser: user)
        updateProjects()
    }

    func updateInfo(withUser user: User) {
        if avatarNode.url?.absoluteString != user.imageURL {
            avatarNode = constructAvatarNode()
        }

        if nameNode.text != user.displayName {
            nameNode.text = user.displayName
        }

        if loginNode.text != user.login {
            loginNode.text = user.login
        }
    }

    func updateStats(withUser user: User) {
        let wallet: String = {
            guard
                let wallet = user.wallet
            else {
                return "—"
            }

            return "\(wallet) ₳"
        }()

        if stats.Wallet.valueNode.text != wallet {
            stats.Wallet.valueNode.text = wallet
        }

        let location: String = {
            guard
                let location = user.location
            else {
                return "—"
            }

            return location
        }()

        if stats.Location.valueNode.text != location {
            stats.Location.valueNode.text = location

            stats.Location.titleNode.text = {
                guard location != nil else {
                    return "Unavailable"
                }

                return "Available"
            }()
        }

        let points: String = {
            guard
                let correctionPoint = user.correctionPoint
            else {
                return "—"
            }

            return "\(correctionPoint)"
        }()

        if stats.Points.valueNode.text != points {
            stats.Points.valueNode.text = points
        }
    }

    func updateContacts(withUser user: User) {
        phoneValueNode.tintColor = Asset.Colors.neutral40.color

        if let phone = user.phone {
            if PhoneNumberKit().isValidPhoneNumber(phone) {
                phoneValueNode.tintColor = Asset.Colors.tiffany50.color
            }

            phoneValueNode.text = phone
        } else {
            phoneValueNode.text = "—"
        }

        emailValueNode.tintColor = Asset.Colors.neutral40.color

        if let email = user.email {
            if email.isValidEmail {
                emailValueNode.tintColor = Asset.Colors.tiffany50.color
            }

            emailValueNode.text = email
        } else {

            emailValueNode.text = "—"
        }
    }

    func updateCursus(withUser user: User) {
        guard let lastCursus = user.cursusUsers?.max(by: { $0.id < $1.id }) else { return }

        if let level = lastCursus.level {
            levelNode.level = Decimal(level)
        }

        if let cursus = lastCursus.cursus {
            selectedCursus = cursus
        }

        if let userSkills = lastCursus.skills {
            Task { [weak self] in
                guard
                    let skills = try? await delegate.skills(forCursus: lastCursus.cursusID)
                else {
                    return
                }

                let allUserSkills: [(String, CGFloat)] = skills.map { skill in
                    (skill.name, userSkills.first(where: { $0.id == skill.id })?.level ?? 0)
                }

                self?.skills = allUserSkills
            }
        }

        func constructCursusMenu() -> UIMenu {
            UIMenu(
                options: .singleSelection,
                children: user.cursusUsers?
                    .sorted(by: {
                        guard
                            let leftUpdatedAt = $0.updatedAt,
                            let rightUpdatedAt = $1.updatedAt
                        else { return false }

                        return leftUpdatedAt < rightUpdatedAt
                    })
                    .map { cursusUser in
                        UIAction(
                            title: cursusUser.cursus?.name ?? "—",
                            image: UIImage?.none,
                            identifier: nil,
                            discoverabilityTitle: nil,
                            state: cursusUser.cursusID == selectedCursus?.id ? .on : .off,
                            handler: { [weak self] _ in

                                if let level = cursusUser.level {
                                    self?.levelNode.level = Decimal(level)
                                }

                                if let cursus = cursusUser.cursus {
                                    self?.selectedCursus = cursus
                                }

                                if let userSkills = cursusUser.skills {
                                    Task { [weak self] in
                                        guard
                                            let skills = try? await self?.delegate
                                                .skills(forCursus: cursusUser.cursusID)
                                        else {
                                            return
                                        }

                                        let allUserSkills: [(String, CGFloat)] = skills.map {
                                            skill in
                                            (
                                                skill.name,
                                                userSkills.first(where: { $0.id == skill.id })?
                                                    .level
                                                    ?? 0
                                            )
                                        }

                                        self?.skills = allUserSkills
                                    }
                                }

                                self?.updateProjects()

                                self?.cursusMenu = constructCursusMenu()
                            }
                        )
                    } ?? []
            )
        }

        cursusMenu = constructCursusMenu()
    }

    func updateProjects() {
        ASPerformBlockOnMainThread { [weak self] in
            self?.projectsTableNode
                .reloadData {
                    self?.projectsTableNode
                        .needsUpdateHeightToFit = true

                    self?.projectsTableNode
                        .transitionLayout(
                            withAnimation: true,
                            shouldMeasureAsync: false
                        )

                    self?.scrollNode
                        .transitionLayout(
                            withAnimation: true,
                            shouldMeasureAsync: false
                        )
                }
        }
    }

    // MARK: - Layout Specs

    var cursusLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            HStack(alignItems: .center) {
                Spacer(minLength: 16, flexGrow: 0)

                cursusActionTitleNode
                    .flexGrow(1)

                if selectedCursus != nil {
                    cursusActionChevronNode
                } else {
                    ASLayoutSpec()
                }

                Spacer(minLength: 16, flexGrow: 0)
            }
            .overlay(cursusActionNode.contextNode)
        }
    }

    var contactsLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                phoneNode

                contactsSeparatorNode
                    .padding(.left, 20)

                emailNode
            }
        }
    }

    var phoneLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                phoneTitleNode
                phoneValueNode
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
        }
    }

    var emailLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack {
                emailTitleNode
                emailValueNode
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
        }
    }

    var scrollLayoutSpec: ASLayoutSpec {
        LayoutSpec {
            VStack(spacing: 32, isConcurrent: true) {
                VStack(spacing: 12) {
                    avatarNode
                        .alignSelf(.center)

                    VStack(spacing: 2, alignItems: .center) {
                        nameNode
                        loginNode
                    }

                    HStack(justifyContent: .spaceBetween) {
                        Spacer(minLength: 12, flexGrow: 0)

                        stats.Wallet.layoutSpec
                        stats.Separators.0
                        stats.Location.layoutSpec
                        stats.Separators.1
                        stats.Points.layoutSpec

                        Spacer(minLength: 12, flexGrow: 0)
                    }

                    levelNode
                        .spacingBefore(8)
                        .preferredLayoutHeight(32)
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .background(gradientNode)

                VStack(spacing: 8) {
                    cursusTitleNode
                        .padding(.left, 16)

                    cursusActionNode
                        .preferredLayoutSize(width: .auto, height: 48)
                }

                contactsNode

                if !delegate.isProjectsEmpty {
                    VStack(spacing: 8) {
                        projectsTitleNode
                            .padding(.left, 16)

                        projectsTableNode
                    }
                } else {
                    ASLayoutSpec()
                }

                if skills != nil {
                    VStack(spacing: 8) {
                        skillsTitleNode
                            .padding(.left, 16)

                        skillsNode
                            .aspectRatio(1)
                    }
                } else {
                    ASLayoutSpec()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }

    override public func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
        LayoutSpec {
            if delegate?.user != nil || delegate?.basicUser != nil {
                scrollNode
            } else {
                ASLayoutSpec()
            }
        }
    }
}
