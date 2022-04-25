//
//  File.swift
//
//
//  Created by Nikita Arutyunov on 06.02.2022.
//

import AsyncDisplayKit
import UIKit

open class SCSwitchNode: SCDisplayNode {
    open var isOn: Bool {
        get {
            switchView?.isOn ?? false
        }

        set {
            ASPerformBlockOnMainThread { [weak self] in
                self?.switchView?.isOn = newValue
            }
        }
    }

    open var onTintColor: UIColor? {
        get {
            switchView?.onTintColor
        }

        set {
            ASPerformBlockOnMainThread { [weak self] in
                self?.switchView?.onTintColor = newValue
            }
        }
    }

    override open var tintColor: UIColor? {
        get {
            switchView?.tintColor
        }

        set {
            ASPerformBlockOnMainThread { [weak self] in
                self?.switchView?.tintColor = newValue
            }
        }
    }

    open var thumbTintColor: UIColor? {
        get {
            switchView?.thumbTintColor
        }

        set {
            ASPerformBlockOnMainThread { [weak self] in
                self?.switchView?.thumbTintColor = newValue
            }
        }
    }

    open var switchView: UISwitch? {
        view as? UISwitch
    }

    open var valueChangedBlock: ((SCSwitchNode) -> Void)?

    @objc
    func valueChanged() {
        valueChangedBlock?(self)
    }

    public init(
        isOn: Bool? = nil,
        onTintColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        thumbTintColor: UIColor? = nil
    ) {
        super.init()

        isLayerBacked = false

        setViewBlock { [self] in
            let switchView = UISwitch()

            if let isOn = isOn {
                switchView.isOn = isOn
            }

            if let onTintColor = onTintColor {
                switchView.onTintColor = onTintColor
            }

            if let tintColor = tintColor {
                switchView.tintColor = tintColor
            }

            if let thumbTintColor = thumbTintColor {
                switchView.thumbTintColor = thumbTintColor
            }

            switchView.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

            return switchView
        }
    }

    open func setOn(_ on: Bool = true, animated: Bool = true) {
        ASPerformBlockOnMainThread { [weak self] in
            self?.switchView?.setOn(on, animated: animated)
        }
    }
}
