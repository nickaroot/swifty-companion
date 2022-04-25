//
//  SCSkillsMap.swift
//  SCProfile
//
//  Created by Nikita Arutyunov on 14.04.2022.
//

import UIKit

struct SCSkillsMap {
    let skills: [(String, CGFloat)]

    let radius: CGFloat

    let boundWidth: CGFloat
    let boundColor: UIColor

    let circlesWidth: CGFloat
    let circlesColor: UIColor

    let skillsWidth: CGFloat
    let skillsColor: UIColor

    let scaleFactor: CGFloat

    var layer: CALayer {
        let step = radius / 4

        let boundLayer: CALayer = {
            let path = UIBezierPath(
                arcCenter: CGPoint(x: radius, y: radius),
                radius: radius,
                startAngle: 0,
                endAngle: 2 * .pi,
                clockwise: true
            )

            path.append(
                UIBezierPath(
                    arcCenter: CGPoint(x: radius, y: radius),
                    radius: radius - boundWidth,
                    startAngle: 0,
                    endAngle: 2 * .pi,
                    clockwise: true
                )
                .reversing()
            )

            let layer = CAShapeLayer()

            layer.path = path.cgPath
            layer.fillColor = boundColor.cgColor

            return layer
        }()

        let circlesLayer: CALayer = {
            let path = UIBezierPath(
                arcCenter: CGPoint(x: radius, y: radius),
                radius: radius - step,
                startAngle: 0,
                endAngle: 2 * .pi,
                clockwise: true
            )

            path.append(
                UIBezierPath(
                    arcCenter: CGPoint(x: radius, y: radius),
                    radius: radius - circlesWidth - step,
                    startAngle: 0,
                    endAngle: 2 * .pi,
                    clockwise: true
                )
                .reversing()
            )

            path.append(
                UIBezierPath(
                    arcCenter: CGPoint(x: radius, y: radius),
                    radius: radius - step * 2,
                    startAngle: 0,
                    endAngle: 2 * .pi,
                    clockwise: true
                )
            )

            path.append(
                UIBezierPath(
                    arcCenter: CGPoint(x: radius, y: radius),
                    radius: radius - circlesWidth - step * 2,
                    startAngle: 0,
                    endAngle: 2 * .pi,
                    clockwise: true
                )
                .reversing()
            )

            path.append(
                UIBezierPath(
                    arcCenter: CGPoint(x: radius, y: radius),
                    radius: radius - step * 3,
                    startAngle: 0,
                    endAngle: 2 * .pi,
                    clockwise: true
                )
            )

            path.append(
                UIBezierPath(
                    arcCenter: CGPoint(x: radius, y: radius),
                    radius: radius - circlesWidth - step * 3,
                    startAngle: 0,
                    endAngle: 2 * .pi,
                    clockwise: true
                )
                .reversing()
            )

            let layer = CAShapeLayer()

            layer.path = path.cgPath
            layer.fillColor = circlesColor.cgColor

            return layer
        }()

        let linesLayer: CALayer = {
            let path = UIBezierPath()

            for i in 0..<skills.count {
                let angle = CGFloat(.pi + .pi * 2 / Double(skills.count) * Double(i))

                path.move(to: CGPoint(x: radius, y: radius))
                path.addLine(
                    to: CGPoint(x: radius + sin(angle) * radius, y: radius + cos(angle) * radius)
                )
            }

            let layer = CAShapeLayer()

            layer.path = path.cgPath
            layer.strokeColor =
                UIColor(displayP3Red: 220 / 255, green: 221 / 255, blue: 221 / 255, alpha: 1)
                .cgColor

            return layer
        }()

        let skillsLayer: CALayer = {
            let path = UIBezierPath()

            let pie = .pi * 2 / Double(skills.count)

            let angle = CGFloat(.pi + pie * Double(0) + pie / 2)

            if !skills.isEmpty {
                path.move(
                    to: CGPoint(
                        x: radius + sin(angle) * skills[0].1 * scaleFactor,
                        y: radius + cos(angle) * skills[0].1 * scaleFactor
                    )
                )

                for i in 1..<skills.count {
                    let pie = .pi * 2 / Double(skills.count)

                    let angle = CGFloat(.pi + pie * Double(i) + pie / 2)

                    let currentSkill = skills[i].1

                    path.addLine(
                        to: CGPoint(
                            x: radius + sin(angle) * currentSkill * scaleFactor,
                            y: radius + cos(angle) * currentSkill * scaleFactor
                        )
                    )
                }

                path.addLine(
                    to: CGPoint(
                        x: radius + sin(angle) * skills[0].1 * scaleFactor,
                        y: radius + cos(angle) * skills[0].1 * scaleFactor
                    )
                )
            }

            let layer = CAShapeLayer()

            layer.path = path.cgPath
            layer.lineWidth = skillsWidth
            layer.strokeColor = skillsColor.cgColor
            layer.fillColor = skillsColor.withAlphaComponent(0.75).cgColor
            layer.lineCap = .round
            layer.lineJoin = .round

            return layer
        }()

        boundLayer.addSublayer(circlesLayer)
        boundLayer.addSublayer(linesLayer)
        boundLayer.addSublayer(skillsLayer)

        return boundLayer
    }

    // MARK: - Pie Points

    typealias Pie = (action: (CGPoint, CGPoint, CGPoint), indicator: CGPoint)

    var pies: [Pie] {
        (0..<skills.count)
            .map {
                let pie = .pi * 2 / Double(skills.count)

                let angle = CGFloat(.pi + pie * Double($0) + pie / 2)

                let startAngle = CGFloat(.pi + pie * Double($0))

                let endAngle = CGFloat(.pi + pie * Double($0) + pie)

                let currentSkill = skills[$0].1

                let piePoints = (
                    (
                        CGPoint(
                            x: radius,
                            y: radius
                        ),
                        CGPoint(
                            x: radius + sin(startAngle) * (radius * 1.5),
                            y: radius + cos(startAngle) * (radius * 1.5)
                        ),
                        CGPoint(
                            x: radius + sin(endAngle) * (radius * 1.5),
                            y: radius + cos(endAngle) * (radius * 1.5)
                        )
                    ),
                    CGPoint(
                        x: radius + sin(angle) * currentSkill * scaleFactor,
                        y: radius + cos(angle) * currentSkill * scaleFactor
                    )
                )

                return piePoints
            }
    }

    var actionPoints: [CGPoint] {
        (0..<skills.count)
            .map {
                let pie = .pi * 2 / Double(skills.count)

                let angle = CGFloat(.pi + pie * Double($0) + pie / 2)

                let currentSkill = skills[$0].1

                return CGPoint(
                    x: radius + sin(angle) * currentSkill * scaleFactor,
                    y: radius + cos(angle) * currentSkill * scaleFactor
                )
            }
    }

    var actionPies: [(CGPoint, CGPoint, CGPoint)] {
        (0..<skills.count)
            .map {
                let pie = .pi * 2 / Double(skills.count)

                let startAngle = CGFloat(.pi + pie * Double($0))

                let endAngle = CGFloat(.pi + pie * Double($0) + pie)

                return (
                    CGPoint(
                        x: radius,
                        y: radius
                    ),
                    CGPoint(
                        x: radius + sin(startAngle) * radius,
                        y: radius + cos(startAngle) * radius
                    ),
                    CGPoint(
                        x: radius + sin(endAngle) * radius,
                        y: radius + cos(endAngle) * radius
                    )
                )
            }
    }

    func titlePoints(offset: CGFloat) -> [CGPoint] {
        (0..<skills.count)
            .map {
                let pie = .pi * 2 / Double(skills.count)

                let currentPie = pie * Double($0)

                let semiPie = pie / 2

                let angle: CGFloat = .pi + currentPie + semiPie

                return CGPoint(
                    x: radius + (radius + offset) * sin(angle),
                    y: radius + (radius + offset) * cos(angle)
                )
            }
    }

    init(
        skills: [(String, CGFloat)],
        radius: CGFloat,
        boundWidth: CGFloat,
        boundColor: UIColor,
        circlesWidth: CGFloat,
        circlesColor: UIColor,
        skillsWidth: CGFloat,
        skillsColor: UIColor
    ) {
        self.skills = skills
        self.radius = radius
        self.boundWidth = boundWidth
        self.boundColor = boundColor
        self.circlesWidth = circlesWidth
        self.circlesColor = circlesColor
        self.skillsWidth = skillsWidth
        self.skillsColor = skillsColor

        self.scaleFactor = radius / 20
    }
}
