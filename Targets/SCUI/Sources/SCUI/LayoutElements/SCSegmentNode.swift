//
//  SCSegmentNode.swift
//
//
//  Created by Nikita Arutyunov on 20.12.2021.
//

import AsyncDisplayKit
import SCAssets
import UIKit

open class SCSegmentNode: ASDisplayNode, SCElement {
    open var segmentView: UISegmentedControl? { view as? UISegmentedControl }

    @available(iOS 13, *) open var selectedImageView: UIImageView? {
        segmentView?.subviews.first(where: { ($0 as? UIImageView)?.subviews.isEmpty ?? false })
            as? UIImageView
    }

    open var initialSelectedImageOffsetX: CGFloat?

    public var selectedSegmentIndex: Int {
        get {
            guard let segmentView = view as? UISegmentedControl else { return 0 }

            return segmentView.selectedSegmentIndex
        }

        set { segmentView?.selectedSegmentIndex = newValue }
    }

    override open var tintColor: UIColor? {
        get {
            guard let segmentView = view as? UISegmentedControl else { return .clear }

            return segmentView.tintColor
        }

        set {
            ASPerformBlockOnMainThread { [weak self] in
                guard let segmentView = self?.view as? UISegmentedControl else { return }

                segmentView.tintColor = newValue
            }
        }
    }

    public weak var delegate: SCSegmentDelegate?

    public init(
        _ items: [String]
    ) {
        super.init()

        isLayerBacked = false

        setViewBlock { UISegmentedControl(items: items) }

        onDidLoad { node in

            guard let segmentView = node.view as? UISegmentedControl else { return }

            segmentView.tintColor = .white
            segmentView.selectedSegmentIndex = 0
        }
    }

    override open func didLoad() {
        super.didLoad()

        segmentView?.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

    @objc func valueChanged(_: ASControlNode) {
        delegate?.segmentNode(self, selectedIndexDidChanged: selectedSegmentIndex)
    }
}
