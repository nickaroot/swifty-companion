//
//  SCNotifications+StatusLine.swift
//  SCUI
//
//  Created by Nikita Arutyunov on 24.03.2022.
//

import SCAssets
import SwiftMessages
import UIKit

extension SCNotifications {

    // MARK: - Status Line

    public enum StatusLine {

        // MARK: - Message View

        public static var messageView: MessageView? {
            guard let bundle = Bundle(identifier: "SCAssets.resources") else { return nil }

            return try? MessageView.viewFromNib(layout: .statusLine, bundle: bundle)
        }

        // MARK: - Error Message

        public enum ErrorMessage: SCNotificationsMessage {

            public static var config: SwiftMessages.Config {
                var config = SwiftMessages.Config()

                config.preferredStatusBarStyle = .lightContent
                config.presentationContext = .window(windowLevel: .statusBar)

                return config
            }

            public static func show(
                _ content: Content,
                isHideOnTapEnabled: Bool = true,
                isAutoHide: Bool = true,
                configModifier: ((SwiftMessages.Config) -> SwiftMessages.Config)? = nil
            ) {
                var config = configModifier?(config) ?? config

                if !isAutoHide {
                    config.duration = .forever
                }

                UINotificationFeedbackGenerator().notificationOccurred(.error)

                SwiftMessages.show(config: config) {
                    guard let messageView = messageView else { return MessageView() }

                    messageView.configureTheme(
                        backgroundColor: Asset.Colors.red50.color,
                        foregroundColor: Asset.Colors.neutral0.color
                    )

                    messageView.configureContent(content)

                    if isHideOnTapEnabled {
                        messageView.tapHandler = { _ in
                            SwiftMessages.hide(id: messageView.id)
                        }
                    }

                    return messageView
                }
            }

        }

        // MARK: - Success Message

        public enum SuccessMessage: SCNotificationsMessage {

            public static var config: SwiftMessages.Config {
                var config = SwiftMessages.Config()

                config.preferredStatusBarStyle = .lightContent
                config.presentationContext = .window(windowLevel: .statusBar)

                return config
            }

            public static func show(
                _ content: Content,
                isHideOnTapEnabled: Bool = true,
                isAutoHide: Bool = true,
                configModifier: ((SwiftMessages.Config) -> SwiftMessages.Config)? = nil
            ) {
                var config = configModifier?(config) ?? config

                if !isAutoHide {
                    config.duration = .forever
                }

                UINotificationFeedbackGenerator().notificationOccurred(.success)

                SwiftMessages.show(config: config) {
                    guard let messageView = messageView else { return MessageView() }

                    messageView.configureTheme(
                        backgroundColor: Asset.Colors.green50.color,
                        foregroundColor: Asset.Colors.neutral0.color
                    )

                    messageView.configureContent(content)

                    if isHideOnTapEnabled {
                        messageView.tapHandler = { _ in
                            SwiftMessages.hide(id: messageView.id)
                        }
                    }

                    return messageView
                }
            }

        }

        // MARK: - Info Message

        public enum InfoMessage: SCNotificationsMessage {

            public static var config: SwiftMessages.Config {
                var config = SwiftMessages.defaultConfig

                config.preferredStatusBarStyle = .lightContent
                config.presentationContext = .window(windowLevel: .statusBar)

                return config
            }

            public static func show(
                _ content: Content,
                isHideOnTapEnabled: Bool = true,
                isAutoHide: Bool = true,
                configModifier: ((SwiftMessages.Config) -> SwiftMessages.Config)? = nil
            ) {
                var config = configModifier?(config) ?? config

                if !isAutoHide {
                    config.duration = .forever
                }

                UINotificationFeedbackGenerator().notificationOccurred(.warning)

                SwiftMessages.show(config: config) {
                    guard let messageView = messageView else { return MessageView() }

                    messageView.configureTheme(
                        backgroundColor: Asset.Colors.neutral50.color,
                        foregroundColor: Asset.Colors.neutral0.color
                    )

                    messageView.configureContent(content)

                    if isHideOnTapEnabled {
                        messageView.tapHandler = { _ in
                            SwiftMessages.hide(id: messageView.id)
                        }
                    }

                    return messageView
                }
            }
        }

    }

}
