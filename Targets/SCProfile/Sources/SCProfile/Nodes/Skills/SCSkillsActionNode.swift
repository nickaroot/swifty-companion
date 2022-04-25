//
//  SCSkillsActionNode.swift
//  SCProfile
//
//  Created by Nikita Arutyunov on 15.04.2022.
//

import AsyncDisplayKit
import SCUI

class SCSkillsActionNode: SCActionNode {
    // MARK: - Pie

    let pie: (CGPoint, CGPoint, CGPoint)

    var piePath: UIBezierPath {
        let path = UIBezierPath()

        path.move(to: convert(pie.0, from: supernode))

        path.addLine(to: convert(pie.1, from: supernode))
        path.addLine(to: convert(pie.2, from: supernode))
        path.addLine(to: convert(pie.0, from: supernode))

        return path
    }

    // MARK: - Pie Highlight Layer

    let highlightColor: UIColor

    lazy var pieHighlightLayer: CALayer = {
        let layer = CAShapeLayer()

        layer.path = piePath.cgPath

        layer.fillColor = highlightColor.cgColor

        layer.opacity = 0

        return layer
    }()

    // MARK: - Init

    init(
        pie: (CGPoint, CGPoint, CGPoint),
        highlightColor: UIColor
    ) {
        self.pie = pie
        self.highlightColor = highlightColor
    }

    // MARK: - Layout Did Finish

    override func layoutDidFinish() {
        super.layoutDidFinish()

        view.layer.addSublayer(pieHighlightLayer)
    }

    // MARK: - Hit Test

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let supernode = supernode else { return nil }

        if piePath.contains(point) {
            return view
        } else {
            return nil
        }
    }
}
