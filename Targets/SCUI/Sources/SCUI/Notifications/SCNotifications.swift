//
//  SCNotifications.swift
//  SCUI
//
//  Created by Nikita Arutyunov on 24.03.2022.
//

import SwiftMessages
import UIKit

public enum SCNotifications {

    // MARK: - Content

    public struct Content {
        var title: String?
        var body: String?
        var iconImage: UIImage?
        var iconText: String?
        var buttonImage: UIImage?
        var buttonTitle: String?

        public init(
            title: String? = nil,
            body: String? = nil,
            iconImage: UIImage? = nil,
            iconText: String? = nil,
            buttonImage: UIImage? = nil,
            buttonText: String? = nil
        ) {
            self.title = title
            self.body = body

            self.iconImage = iconImage
            self.iconText = iconText

            self.buttonImage = buttonImage
            self.buttonTitle = buttonText
        }
    }

}

// MARK: - Message

public protocol SCNotificationsMessage {
    static var config: SwiftMessages.Config { get }

    static func show(
        _ content: SCNotifications.Content,
        isHideOnTapEnabled: Bool,
        isAutoHide: Bool,
        configModifier: ((SwiftMessages.Config) -> SwiftMessages.Config)?
    )
}

// MARK: - Configure Content

extension MessageView {
    public func configureContent(
        _ content: SCNotifications.Content,
        buttonTapHandler: ((UIButton) -> Void)? = nil
    ) {
        configureContent(
            title: content.title,
            body: content.body,
            iconImage: content.iconImage,
            iconText: content.iconText,
            buttonImage: content.buttonImage,
            buttonTitle: content.buttonTitle,
            buttonTapHandler: buttonTapHandler
        )

        titleLabel?.isHidden = content.title == nil
        bodyLabel?.isHidden = content.body == nil
        iconImageView?.isHidden = content.iconImage == nil
        iconLabel?.isHidden = content.iconText == nil
        button?.isHidden = content.buttonImage == nil && content.buttonTitle == nil
    }
}
