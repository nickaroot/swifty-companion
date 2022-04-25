//
//  SCSkillsNode.swift
//  SCProfile
//
//  Created by Nikita Arutyunov on 14.04.2022.
//

import AsyncDisplayKit
import SCAssets
import SCUI
import TextureUI

class SCSkillsNode: SCActionNode {
    let skills: [(String, CGFloat)]

    var constrainedSize: ASSizeRange?

    // MARK: - Map

    lazy var map = SCSkillsMap(
        skills: skills,
        radius: (constrainedSize?.min.width ?? 0) * 0.3,
        boundWidth: 2,
        boundColor: UIColor(
            displayP3Red: 194 / 255,
            green: 207 / 255,
            blue: 222 / 255,
            alpha: 1
        ),
        circlesWidth: 1,
        circlesColor: UIColor(
            displayP3Red: 220 / 255,
            green: 221 / 255,
            blue: 221 / 255,
            alpha: 1
        ),
        skillsWidth: 2,
        skillsColor: UIColor(
            displayP3Red: 82 / 255,
            green: 183 / 255,
            blue: 186 / 255,
            alpha: 1
        )
    )

    lazy var mapNode: SCDisplayNode = {
        let node = SCDisplayNode { [unowned self] in
            map.layer
        } didLoad: { node in

        }

        node.style.preferredLayoutSize = ASLayoutSize(
            width: .points(map.radius * 2),
            height: .points(map.radius * 2)
        )

        return node
    }()

    // MARK: - Titles

    lazy var titlePoints = map.titlePoints(offset: 8)

    var translatedTitlePoints: [CGPoint]?

    var selectedTitleIndex: Int? {
        didSet {
            if let previousSelectedTitleIndex = oldValue,
                previousSelectedTitleIndex >= 0, previousSelectedTitleIndex < titleNodes.count
            {
                let previousTitleNode = titleNodes[previousSelectedTitleIndex]

                previousTitleNode.typography = previousTitleNode.typography.with(
                    underline: (nil, nil)
                )

                previousTitleNode.text = previousTitleNode.text
            }

            if let currentSelectedTitleIndex = selectedTitleIndex,
                currentSelectedTitleIndex >= 0, currentSelectedTitleIndex < titleNodes.count
            {
                let currentTitleNode = titleNodes[currentSelectedTitleIndex]

                currentTitleNode.typography = currentTitleNode.typography.with(
                    underline: (NSUnderlineStyle.single, currentTitleNode.tintColor)
                )

                currentTitleNode.text = currentTitleNode.text
            }
        }
    }

    lazy var titleNodes: [SCTextNode] = {
        translatedTitlePoints?.enumerated()
            .map { [map] (i, translatedPoint) in
                let typography: SCTypography = {
                    if titlePoints[i].x < map.radius {
                        return SCTypography.caption2.with(
                            font: .systemFont(ofSize: 6, weight: .medium),
                            lineHeight: 7,
                            alignment: .right
                        )
                    } else if titlePoints[i].x == map.radius {
                        return SCTypography.caption2.with(
                            font: .systemFont(ofSize: 6, weight: .medium),
                            lineHeight: 7,
                            alignment: .center
                        )
                    } else {
                        return SCTypography.caption2.with(
                            font: .systemFont(ofSize: 6, weight: .medium),
                            lineHeight: 7,
                            alignment: .left
                        )
                    }
                }()

                let node = SCTextNode(typography: typography)

                node.style.layoutPosition = translatedPoint

                if titlePoints[i].x < map.radius {
                    node.style.maxWidth = .points(calculatedSize.width * 0.2 - 20)
                } else if titlePoints[i].x == map.radius {
                    node.style.maxWidth = .points(calculatedSize.width * 0.2 - 40)
                } else {
                    node.style.maxWidth = .points(calculatedSize.width * 0.2 - 20)
                }

                node.tintColor = Asset.Colors.neutral50.color

                node.text = map.skills[i].0

                return node
            } ?? []
    }()

    // MARK: - Pies

    typealias PieNodes = (
        action: SCSkillsActionNode,
        indicator: SCDisplayNode,
        valueTitle: SCTextNode,
        valueBackground: SCDisplayNode
    )

    lazy var pies = map.pies

    var translatedPies: [SCSkillsMap.Pie]?

    let pieIndicatorRadius = CGFloat(4)

    var selectedPieNodes: PieNodes? {
        didSet {
            if let previousSelectedPieNodes = oldValue {
                let animation = CATransition()

                animation.timingFunction = CAMediaTimingFunction(name: .default)
                animation.type = .fade
                animation.duration = touchAnimationDuration

                previousSelectedPieNodes.indicator.layer.add(
                    animation,
                    forKey: CATransitionType.fade.rawValue
                )

                previousSelectedPieNodes.action.pieHighlightLayer.add(
                    animation,
                    forKey: CATransitionType.fade.rawValue
                )

                previousSelectedPieNodes.indicator.border = SCBorder(
                    color: Asset.Colors.neutral0.color.withAlphaComponent(0),
                    width: 1,
                    radius: pieIndicatorRadius
                )

                previousSelectedPieNodes.indicator.backgroundColor = Asset.Colors.tiffany50.color
                    .withAlphaComponent(0)

                previousSelectedPieNodes.action.pieHighlightLayer.opacity = 0
                previousSelectedPieNodes.valueTitle.layer.opacity = 0
                previousSelectedPieNodes.valueBackground.layer.opacity = 0
            }

            if let currentSelectedPieNodes = selectedPieNodes {
                currentSelectedPieNodes.indicator.border = SCBorder(
                    color: Asset.Colors.neutral0.color,
                    width: 1,
                    radius: pieIndicatorRadius
                )

                currentSelectedPieNodes.indicator.backgroundColor = Asset.Colors.tiffany50.color

                currentSelectedPieNodes.action.pieHighlightLayer.opacity = 1
                currentSelectedPieNodes.valueTitle.layer.opacity = 1
                currentSelectedPieNodes.valueBackground.layer.opacity = 1
            }
        }
    }

    lazy var piesNodes: [PieNodes] = {
        translatedPies?.enumerated()
            .map { [map] (i, translatedPiePoint) in
                let indicatorNode: SCDisplayNode = {
                    let node = SCDisplayNode()

                    node.style.preferredLayoutSize = ASLayoutSize(
                        width: .points(pieIndicatorRadius * 2),
                        height: .points(pieIndicatorRadius * 2)
                    )

                    node.style.layoutPosition = CGPoint(
                        x: translatedPiePoint.indicator.x - pieIndicatorRadius,
                        y: translatedPiePoint.indicator.y - pieIndicatorRadius
                    )

                    node.border = SCBorder(
                        color: Asset.Colors.neutral0.color.withAlphaComponent(0),
                        width: 1,
                        radius: pieIndicatorRadius
                    )

                    node.backgroundColor = Asset.Colors.tiffany50.color.withAlphaComponent(0)

                    return node
                }()

                let actionNode = SCSkillsActionNode(
                    pie: translatedPiePoint.action,
                    highlightColor: .clear  // map.circlesColor.withAlphaComponent(0.25)
                )

                let rect: CGRect = {
                    let points = [
                        translatedPiePoint.action.0, translatedPiePoint.action.1,
                        translatedPiePoint.action.2,
                    ]

                    guard let minX = points.min(by: { $0.x < $1.x })?.x,
                        let maxX = points.max(by: { $0.x < $1.x })?.x,
                        let minY = points.min(by: { $0.y < $1.y })?.y,
                        let maxY = points.max(by: { $0.y < $1.y })?.y
                    else { return .zero }

                    return CGRect(
                        x: minX,
                        y: minY,
                        width: maxX - minX,
                        height: maxY - minY
                    )
                }()

                actionNode.style.layoutPosition = rect.origin
                actionNode.style.preferredSize = rect.size

                let valueTitleNode: SCTextNode = {
                    let skill = map.skills[i]

                    let node = SCTextNode(typography: .caption2)

                    node.style.layoutPosition = translatedPiePoint.indicator

                    node.tintColor = Asset.Colors.neutral50.color

                    node.text = skill.1.description

                    return node
                }()

                let valueBackgroundNode: SCDisplayNode = {
                    let node = SCDisplayNode()

                    node.backgroundColor = Asset.Colors.neutral0.color.withAlphaComponent(0.75)

                    if let filter = CIFilter(name: "CIGaussianBlur") {
                        filter.name = "myFilter"
                        layer.backgroundFilters = [filter]
                        layer.setValue(
                            2,
                            forKeyPath: "backgroundFilters.myFilter.inputRadius"
                        )
                    }

                    return node
                }()

                valueTitleNode.layer.opacity = 0
                valueBackgroundNode.layer.opacity = 0

                let pieNodes = (
                    action: actionNode,
                    indicator: indicatorNode,
                    valueTitle: valueTitleNode,
                    valueBackground: valueBackgroundNode
                )

                actionNode.touchDownBlock = { [weak self] _ in
                    self?.selectedPieNodes = pieNodes

                    self?.selectedTitleIndex = i
                }

                return pieNodes
            } ?? []
    }()

    // MARK: - Init

    init(
        skills: [(String, CGFloat)]
    ) {
        self.skills = skills

        super.init()

        isLayerBacked = false

        transition = []
    }

    // MARK: - Did Load

    override func didLoad() {
        super.didLoad()

        touchDownBlock = { [weak self] _ in
            self?.selectedPieNodes = nil
            self?.selectedTitleIndex = nil
        }
    }

    // MARK: - Layout Did Finish

    var shouldCorrectTitlesPosition = true

    override func layoutDidFinish() {
        super.layoutDidFinish()

        var needsLayout = false

        if translatedTitlePoints == nil {
            translatedTitlePoints = titlePoints.map { convert($0, from: mapNode) }

            needsLayout = true
        } else {
            guard shouldCorrectTitlesPosition else { return }

            for (i, titleNode) in titleNodes.enumerated() {
                if titlePoints[i].x < map.radius {
                    titleNode.style.layoutPosition.x -= titleNode.calculatedSize.width
                } else if titlePoints[i].x == map.radius {
                    titleNode.style.layoutPosition.x -= titleNode.calculatedSize.width / 2
                }

                if titlePoints[i].y < map.radius / 3 {
                    titleNode.style.layoutPosition.y -= titleNode.calculatedSize.height
                } else if titlePoints[i].y < map.radius / 3 * 2 {
                    titleNode.style.layoutPosition.y -= titleNode.calculatedSize.height / 2
                }
            }

            if let translatedPies = translatedPies {

                let horizontalPadding = pieIndicatorRadius * 1.5

                for (i, (_, _, valueTitleNode, valueBackgroundNode)) in piesNodes.enumerated() {
                    if translatedPies[i].indicator.x < calculatedSize.width / 2,
                        translatedPies[i].indicator.y < calculatedSize.height / 2
                    {
                        // MARK: - Left Top Quarter

                        valueTitleNode.style.layoutPosition.x -=
                            valueTitleNode.calculatedSize.width

                        valueTitleNode.style.layoutPosition.y -=
                            valueTitleNode.calculatedSize.height

                        valueBackgroundNode.style.layoutPosition = CGPoint(
                            x: valueTitleNode.style.layoutPosition.x - horizontalPadding,
                            y: valueTitleNode.style.layoutPosition.y
                        )

                        valueBackgroundNode.style.preferredSize = CGSize(
                            width: valueTitleNode.calculatedSize.width + horizontalPadding,
                            height: valueTitleNode.calculatedSize.height
                        )

                        valueTitleNode.style.layoutPosition.x -= horizontalPadding / 2

                        valueBackgroundNode.border = SCBorder(
                            radius: pieIndicatorRadius,
                            corners: [.leftBottom, .leftTop, .rightTop]
                        )
                    } else if translatedPies[i].indicator.x < calculatedSize.width / 2,
                        translatedPies[i].indicator.y >= calculatedSize.height / 2
                    {
                        // MARK: - Left Bottom Quarter

                        valueTitleNode.style.layoutPosition.x -=
                            valueTitleNode.calculatedSize.width

                        valueBackgroundNode.style.layoutPosition = CGPoint(
                            x: valueTitleNode.style.layoutPosition.x - horizontalPadding,
                            y: valueTitleNode.style.layoutPosition.y
                        )

                        valueBackgroundNode.style.preferredSize = CGSize(
                            width: valueTitleNode.calculatedSize.width + horizontalPadding,
                            height: valueTitleNode.calculatedSize.height
                        )

                        valueTitleNode.style.layoutPosition.x -= horizontalPadding / 2

                        valueBackgroundNode.border = SCBorder(
                            radius: pieIndicatorRadius,
                            corners: [.leftBottom, .leftTop, .rightBottom]
                        )
                    } else if translatedPies[i].indicator.x >= calculatedSize.width / 2,
                        translatedPies[i].indicator.y < calculatedSize.height / 2
                    {
                        // MARK: - Right Top Quarter

                        valueTitleNode.style.layoutPosition.y -=
                            valueTitleNode.calculatedSize.height

                        valueBackgroundNode.style.layoutPosition = CGPoint(
                            x: valueTitleNode.style.layoutPosition.x,
                            y: valueTitleNode.style.layoutPosition.y
                        )

                        valueBackgroundNode.style.preferredSize = CGSize(
                            width: valueTitleNode.calculatedSize.width + horizontalPadding,
                            height: valueTitleNode.calculatedSize.height
                        )

                        valueTitleNode.style.layoutPosition.x += horizontalPadding / 2

                        valueBackgroundNode.border = SCBorder(
                            radius: pieIndicatorRadius,
                            corners: [.leftTop, .rightTop, .rightBottom]
                        )
                    } else {
                        // MARK: - Right Bottom Quarter

                        valueBackgroundNode.style.layoutPosition = CGPoint(
                            x: valueTitleNode.style.layoutPosition.x,
                            y: valueTitleNode.style.layoutPosition.y
                        )

                        valueBackgroundNode.style.preferredSize = CGSize(
                            width: valueTitleNode.calculatedSize.width + horizontalPadding,
                            height: valueTitleNode.calculatedSize.height
                        )

                        valueTitleNode.style.layoutPosition.x += horizontalPadding / 2

                        valueBackgroundNode.border = SCBorder(
                            radius: pieIndicatorRadius,
                            corners: [.leftBottom, .rightTop, .rightBottom]
                        )
                    }
                }
            }

            shouldCorrectTitlesPosition = false

            needsLayout = true
        }

        if translatedPies == nil {
            translatedPies = pies.map { (action, indicator) -> SCSkillsMap.Pie in
                (
                    action: (
                        convert(action.0, from: mapNode),
                        convert(action.1, from: mapNode),
                        convert(action.2, from: mapNode)
                    ),
                    indicator: convert(indicator, from: mapNode)
                )
            }

            needsLayout = true
        }

        defer {
            if needsLayout {
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
    }

    // MARK: - Layout Specs

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.constrainedSize = constrainedSize

        return LayoutSpec {
            ZStack {
                if translatedPies != nil {
                    ASAbsoluteLayoutSpec(children: piesNodes.map { $0.action })
                } else {
                    ASLayoutSpec()
                }

                mapNode
                    .relativePosition(horizontal: .center, vertical: .center)

                if translatedTitlePoints != nil {
                    ASAbsoluteLayoutSpec(children: titleNodes)
                } else {
                    ASLayoutSpec()
                }

                if translatedPies != nil {
                    ASAbsoluteLayoutSpec(
                        children: piesNodes.flatMap {
                            [$0.valueBackground, $0.valueTitle, $0.indicator]
                        }
                    )
                } else {
                    ASLayoutSpec()
                }
            }
        }
    }
}
