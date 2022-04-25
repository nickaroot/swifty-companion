//
//  SCLoaderNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import UIKit

open class SCLoaderNode: SCDisplayNode {
    var color: UIColor? { didSet { loaderView?.color = color } }

    open var loaderView: UIActivityIndicatorView? { view as? UIActivityIndicatorView }

    public init(
        style: UIActivityIndicatorView.Style = .medium,
        color: UIColor? = nil
    ) {
        if let color = color { self.color = color }

        super.init()

        isLayerBacked = false

        setViewBlock { UIActivityIndicatorView(style: style) }
    }

    override open func didLoad() {
        super.didLoad()

        loaderView?.color = color ?? .white

        loaderView?.startAnimating()
    }

    public func startAnimating() {
        ASPerformBlockOnMainThread { [weak self] in self?.loaderView?.startAnimating() }
    }

    public func stopAnimating() {
        ASPerformBlockOnMainThread { [weak self] in self?.loaderView?.stopAnimating() }
    }
}
