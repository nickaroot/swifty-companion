//
//  ContainedViewLayoutTransition.swift
//
//
//  Created by Nikita Arutyunov on 23.12.2021.
//

import AsyncDisplayKit
import Foundation
import UIKit

public enum ContainedViewLayoutTransitionCurve: Equatable, Hashable {
    case linear
    case easeInOut
    case spring
    case customSpring(damping: CGFloat, initialVelocity: CGFloat)
    case custom(Float, Float, Float, Float)

    public static var slide: ContainedViewLayoutTransitionCurve {
        return .custom(0.33, 0.52, 0.25, 0.99)
    }
}

//public extension ContainedViewLayoutTransitionCurve {
//    func solve(at offset: CGFloat) -> CGFloat {
//        switch self {
//        case .linear:
//            return offset
//        case .easeInOut:
//            return listViewAnimationCurveEaseInOut(offset)
//        case .spring:
//            return listViewAnimationCurveSystem(offset)
//        case .customSpring:
//            return listViewAnimationCurveSystem(offset)
//        case let .custom(c1x, c1y, c2x, c2y):
//            return bezierPoint(CGFloat(c1x), CGFloat(c1y), CGFloat(c2x), CGFloat(c2y), offset)
//        }
//    }
//}
//
//public extension ContainedViewLayoutTransitionCurve {
//    var timingFunction: String {
//        switch self {
//        case .linear:
//            return CAMediaTimingFunctionName.linear.rawValue
//        case .easeInOut:
//            return CAMediaTimingFunctionName.easeInEaseOut.rawValue
//        case .spring:
//            return kCAMediaTimingFunctionSpring
//        case let .customSpring(damping, initialVelocity):
//            return "\(kCAMediaTimingFunctionCustomSpringPrefix)_\(damping)_\(initialVelocity)"
//        case .custom:
//            return CAMediaTimingFunctionName.easeInEaseOut.rawValue
//        }
//    }
//
//    var mediaTimingFunction: CAMediaTimingFunction? {
//        switch self {
//        case .linear:
//            return nil
//        case .easeInOut:
//            return nil
//        case .spring:
//            return nil
//        case .customSpring:
//            return nil
//        case let .custom(p1, p2, p3, p4):
//            return CAMediaTimingFunction(controlPoints: p1, p2, p3, p4)
//        }
//    }
//
//#if os(iOS)
//    var viewAnimationOptions: UIView.AnimationOptions {
//        switch self {
//        case .linear:
//            return [.curveLinear]
//        case .easeInOut:
//            return [.curveEaseInOut]
//        case .spring:
//            return UIView.AnimationOptions(rawValue: 7 << 16)
//        case .customSpring:
//            return UIView.AnimationOptions(rawValue: 7 << 16)
//        case .custom:
//            return []
//        }
//    }
//#endif
//}

//public enum ContainedViewLayoutTransition {
//    case immediate
//    case animated(duration: Double, curve: ContainedViewLayoutTransitionCurve)
//
//    public var isAnimated: Bool {
//        if case .immediate = self {
//            return false
//        } else {
//            return true
//        }
//    }
//}
//
//public extension CGRect {
//    var ensuredValid: CGRect {
//        if !ASIsCGRectValidForLayout(CGRect(origin: CGPoint(), size: self.size)) {
//            return CGRect()
//        }
//        if !ASIsCGPositionValidForLayout(self.origin) {
//            return CGRect()
//        }
//        return self
//    }
//}
//
//public extension ContainedViewLayoutTransition {
//    func updateFrame(node: ASDisplayNode, frame: CGRect, force: Bool = false, beginWithCurrentState: Bool = false, delay: Double = 0.0, completion: ((Bool) -> Void)? = nil) {
//        if frame.origin.x.isNaN {
//            return
//        }
//        if frame.origin.y.isNaN {
//            return
//        }
//        if frame.size.width.isNaN {
//            return
//        }
//        if frame.size.width < 0.0 {
//            return
//        }
//        if frame.size.height.isNaN {
//            return
//        }
//        if frame.size.height < 0.0 {
//            return
//        }
//        if !ASIsCGRectValidForLayout(CGRect(origin: CGPoint(), size: frame.size)) {
//            return
//        }
//        if !ASIsCGPositionValidForLayout(frame.origin) {
//            return
//        }
//
//        if node.frame.equalTo(frame) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                node.frame = frame
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousFrame: CGRect
//                if beginWithCurrentState, let presentation = node.layer.presentation() {
//                    previousFrame = presentation.frame
//                } else {
//                    previousFrame = node.frame
//                }
//                node.frame = frame
//                node.layer.animateFrame(from: previousFrame, to: frame, duration: duration, delay: delay, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, force: force, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updateFrameAsPositionAndBounds(node: ASDisplayNode, frame: CGRect, force: Bool = false, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if node.frame.equalTo(frame) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                node.position = frame.center
//                node.bounds = CGRect(origin: CGPoint(), size: frame.size)
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousPosition: CGPoint
//                let previousBounds: CGRect
//                if beginWithCurrentState, let presentation = node.layer.presentation() {
//                    previousPosition = presentation.position
//                    previousBounds = presentation.bounds
//                } else {
//                    previousPosition = node.position
//                    previousBounds = node.bounds
//                }
//                node.position = frame.center
//                node.bounds = CGRect(origin: CGPoint(), size: frame.size)
//                node.layer.animateFrame(from:
//                                            CGRect(origin: CGPoint(x: previousPosition.x - previousBounds.width / 2.0, y: previousPosition.y - previousBounds.height / 2.0), size: previousBounds.size), to: frame, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, force: force, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updateFrameAsPositionAndBounds(layer: CALayer, frame: CGRect, force: Bool = false, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if layer.frame.equalTo(frame) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                layer.position = frame.center
//                layer.bounds = CGRect(origin: CGPoint(), size: frame.size)
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousPosition: CGPoint
//                let previousBounds: CGRect
//                if beginWithCurrentState, let presentation = layer.presentation() {
//                    previousPosition = presentation.position
//                    previousBounds = presentation.bounds
//                } else {
//                    previousPosition = layer.position
//                    previousBounds = layer.bounds
//                }
//                layer.position = frame.center
//                layer.bounds = CGRect(origin: CGPoint(), size: frame.size)
//                layer.animateFrame(from:
//                                    CGRect(origin: CGPoint(x: previousPosition.x - previousBounds.width / 2.0, y: previousPosition.y - previousBounds.height / 2.0), size: previousBounds.size), to: frame, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, force: force, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updateFrameAdditive(node: ASDisplayNode, frame: CGRect, force: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if node.frame.equalTo(frame) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                node.frame = frame
//                if let completion = completion {
//                    completion(true)
//                }
//            case .animated:
//                let previousFrame = node.frame
//                node.frame = frame
//                self.animatePositionAdditive(node: node, offset: CGPoint(x: previousFrame.minX - frame.minX, y: previousFrame.minY - frame.minY))
//            }
//        }
//    }
//
//    func updateFrameAdditiveToCenter(node: ASDisplayNode, frame: CGRect, force: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if node.frame.equalTo(frame) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                node.position = frame.center
//                node.bounds = CGRect(origin: node.bounds.origin, size: frame.size)
//                if let completion = completion {
//                    completion(true)
//                }
//            case .animated:
//                let previousCenter = node.frame.center
//                node.position = frame.center
//                node.bounds = CGRect(origin: node.bounds.origin, size: frame.size)
//                self.animatePositionAdditive(node: node, offset: CGPoint(x: previousCenter.x - frame.midX, y: previousCenter.y - frame.midY))
//            }
//        }
//    }
//
//    func updateBounds(node: ASDisplayNode, bounds: CGRect, force: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if node.bounds.equalTo(bounds) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                node.bounds = bounds
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousBounds = node.bounds
//                node.bounds = bounds
//                node.layer.animateBounds(from: previousBounds, to: bounds, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, force: force, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updateBounds(layer: CALayer, bounds: CGRect, force: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if layer.bounds.equalTo(bounds) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                layer.bounds = bounds
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousBounds = layer.bounds
//                layer.bounds = bounds
//                layer.animateBounds(from: previousBounds, to: bounds, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, force: force, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updatePosition(node: ASDisplayNode, position: CGPoint, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if node.position.equalTo(position) {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                node.position = position
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousPosition: CGPoint
//                if beginWithCurrentState {
//                    previousPosition = node.layer.presentation()?.position ?? node.position
//                } else {
//                    previousPosition = node.position
//                }
//                node.position = position
//                node.layer.animatePosition(from: previousPosition, to: position, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updatePosition(layer: CALayer, position: CGPoint, force: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if layer.position.equalTo(position) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                layer.position = position
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousPosition = layer.position
//                layer.position = position
//                layer.animatePosition(from: previousPosition, to: position, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func animatePosition(node: ASDisplayNode, from position: CGPoint, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            node.layer.animatePosition(from: position, to: node.position, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animatePosition(node: ASDisplayNode, to position: CGPoint, removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if !additive && node.position.equalTo(position) {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                node.layer.animatePosition(from: additive ? CGPoint() : node.position, to: position, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: additive, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func animatePositionWithKeyframes(node: ASDisplayNode, keyframes: [AnyObject], removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            completion?(true)
//        case let .animated(duration, curve):
//            node.layer.animateKeyframes(values: keyframes, duration: duration, keyPath: "position", timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, completion: { value in
//                completion?(value)
//            })
//        }
//    }
//
//    func animateFrame(node: ASDisplayNode, from frame: CGRect, to toFrame: CGRect? = nil, removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            node.layer.animateFrame(from: frame, to: toFrame ?? node.layer.frame, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: additive, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animateFrame(layer: CALayer, from frame: CGRect, to toFrame: CGRect? = nil, removeOnCompletion: Bool = true, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            layer.animateFrame(from: frame, to: toFrame ?? layer.frame, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: additive, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animateBounds(layer: CALayer, from bounds: CGRect, removeOnCompletion: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            layer.animateBounds(from: bounds, to: layer.bounds, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animateWidthAdditive(layer: CALayer, value: CGFloat, removeOnCompletion: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            layer.animateWidth(from: value, to: 0.0, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: true, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animateHeightAdditive(layer: CALayer, value: CGFloat, removeOnCompletion: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            layer.animateHeight(from: value, to: 0.0, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: true, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animateOffsetAdditive(node: ASDisplayNode, offset: CGFloat) {
//        switch self {
//        case .immediate:
//            break
//        case let .animated(duration, curve):
//            node.layer.animateBoundsOriginYAdditive(from: offset, to: 0.0, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction)
//        }
//    }
//
//    func animateHorizontalOffsetAdditive(node: ASDisplayNode, offset: CGFloat, completion: (() -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            break
//        case let .animated(duration, curve):
//            node.layer.animateBoundsOriginXAdditive(from: offset, to: 0.0, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { _ in
//                completion?()
//            })
//        }
//    }
//
//    func animateHorizontalOffsetAdditive(layer: CALayer, offset: CGFloat, completion: (() -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            break
//        case let .animated(duration, curve):
//            layer.animateBoundsOriginXAdditive(from: offset, to: 0.0, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { _ in
//                completion?()
//            })
//        }
//    }
//
//    func animateOffsetAdditive(layer: CALayer, offset: CGFloat, completion: (() -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            completion?()
//        case let .animated(duration, curve):
//            layer.animateBoundsOriginYAdditive(from: offset, to: 0.0, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { _ in
//                completion?()
//            })
//        }
//    }
//
//    func animatePositionAdditive(node: ASDisplayNode, offset: CGFloat, removeOnCompletion: Bool = true, completion: @escaping (Bool) -> Void) {
//        switch self {
//        case .immediate:
//            completion(true)
//        case let .animated(duration, curve):
//            node.layer.animatePosition(from: CGPoint(x: 0.0, y: offset), to: CGPoint(), duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: true, completion: completion)
//        }
//    }
//
//    func animatePositionAdditive(layer: CALayer, offset: CGFloat, removeOnCompletion: Bool = true, completion: @escaping (Bool) -> Void) {
//        switch self {
//        case .immediate:
//            completion(true)
//        case let .animated(duration, curve):
//            layer.animatePosition(from: CGPoint(x: 0.0, y: offset), to: CGPoint(), duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: true, completion: completion)
//        }
//    }
//
//    func animatePositionAdditive(node: ASDisplayNode, offset: CGPoint, removeOnCompletion: Bool = true, completion: (() -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            completion?()
//        case let .animated(duration, curve):
//            node.layer.animatePosition(from: offset, to: CGPoint(), duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: true, completion: { _ in
//                completion?()
//            })
//        }
//    }
//
//    func animatePositionAdditive(layer: CALayer, offset: CGPoint, to toOffset: CGPoint = CGPoint(), removeOnCompletion: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            completion?(true)
//        case let .animated(duration, curve):
//            layer.animatePosition(from: offset, to: toOffset, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: true, completion: { result in
//                completion?(result)
//            })
//        }
//    }
//
//    func animateContentsRectPositionAdditive(layer: CALayer, offset: CGPoint, removeOnCompletion: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            completion?(true)
//        case let .animated(duration, curve):
//            layer.animate(from: NSValue(cgPoint: offset), to: NSValue(cgPoint: CGPoint()), keyPath: "contentsRect.origin", timingFunction: curve.timingFunction, duration: duration, delay: 0.0, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: removeOnCompletion, additive: true, completion: completion)
//        }
//    }
//
//    func updateFrame(view: UIView, frame: CGRect, force: Bool = false, beginWithCurrentState: Bool = false, delay: Double = 0.0, completion: ((Bool) -> Void)? = nil) {
//        if frame.origin.x.isNaN {
//            return
//        }
//        if frame.origin.y.isNaN {
//            return
//        }
//        if frame.size.width.isNaN {
//            return
//        }
//        if frame.size.width < 0.0 {
//            return
//        }
//        if frame.size.height.isNaN {
//            return
//        }
//        if frame.size.height < 0.0 {
//            return
//        }
//        if !ASIsCGRectValidForLayout(CGRect(origin: CGPoint(), size: frame.size)) {
//            return
//        }
//        if !ASIsCGPositionValidForLayout(frame.origin) {
//            return
//        }
//
//        if view.frame.equalTo(frame) && !force {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                view.frame = frame
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousFrame: CGRect
//                if beginWithCurrentState, let presentation = view.layer.presentation() {
//                    previousFrame = presentation.frame
//                } else {
//                    previousFrame = view.frame
//                }
//                view.frame = frame
//                view.layer.animateFrame(from: previousFrame, to: frame, duration: duration, delay: delay, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, force: force, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updateFrame(layer: CALayer, frame: CGRect, completion: ((Bool) -> Void)? = nil) {
//        if layer.frame.equalTo(frame) {
//            completion?(true)
//        } else {
//            switch self {
//            case .immediate:
//                layer.frame = frame
//                if let completion = completion {
//                    completion(true)
//                }
//            case let .animated(duration, curve):
//                let previousFrame = layer.frame
//                layer.frame = frame
//                layer.animateFrame(from: previousFrame, to: frame, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            }
//        }
//    }
//
//    func updateAlpha(node: ASDisplayNode, alpha: CGFloat, beginWithCurrentState: Bool = false, force: Bool = false, delay: Double = 0.0, completion: ((Bool) -> Void)? = nil) {
//        if node.alpha.isEqual(to: alpha) && !force {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.alpha = alpha
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousAlpha: CGFloat
//            if beginWithCurrentState, let presentation = node.layer.presentation() {
//                previousAlpha = CGFloat(presentation.opacity)
//            } else {
//                previousAlpha = node.alpha
//            }
//            node.alpha = alpha
//            node.layer.animateAlpha(from: previousAlpha, to: alpha, duration: duration, delay: delay, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateAlpha(layer: CALayer, alpha: CGFloat, completion: ((Bool) -> Void)? = nil) {
//        if layer.opacity.isEqual(to: Float(alpha)) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            layer.opacity = Float(alpha)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousAlpha = layer.opacity
//            layer.opacity = Float(alpha)
//            layer.animateAlpha(from: CGFloat(previousAlpha), to: alpha, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateBackgroundColor(node: ASDisplayNode, color: UIColor, completion: ((Bool) -> Void)? = nil) {
//        if let nodeColor = node.backgroundColor, nodeColor.isEqual(color) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.backgroundColor = color
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            if let nodeColor = node.backgroundColor {
//                node.backgroundColor = color
//                node.layer.animate(from: nodeColor.cgColor, to: color.cgColor, keyPath: "backgroundColor", timingFunction: curve.timingFunction, duration: duration, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                    if let completion = completion {
//                        completion(result)
//                    }
//                })
//            } else {
//                node.backgroundColor = color
//                if let completion = completion {
//                    completion(true)
//                }
//            }
//        }
//    }
//
//    func updateCornerRadius(node: ASDisplayNode, cornerRadius: CGFloat, completion: ((Bool) -> Void)? = nil) {
//        if node.cornerRadius.isEqual(to: cornerRadius) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.cornerRadius = cornerRadius
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousCornerRadius = node.cornerRadius
//            node.cornerRadius = cornerRadius
//            node.layer.animate(from: NSNumber(value: Float(previousCornerRadius)), to: NSNumber(value: Float(cornerRadius)), keyPath: "cornerRadius", timingFunction: curve.timingFunction, duration: duration, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateCornerRadius(layer: CALayer, cornerRadius: CGFloat, completion: ((Bool) -> Void)? = nil) {
//        if layer.cornerRadius.isEqual(to: cornerRadius) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            layer.cornerRadius = cornerRadius
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousCornerRadius = layer.cornerRadius
//            layer.cornerRadius = cornerRadius
//            layer.animate(from: NSNumber(value: Float(previousCornerRadius)), to: NSNumber(value: Float(cornerRadius)), keyPath: "cornerRadius", timingFunction: curve.timingFunction, duration: duration, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animateTransformScale(node: ASDisplayNode, from fromScale: CGFloat, additive: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        let t = node.layer.transform
//        let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        if currentScale.isEqual(to: fromScale) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let calculatedFrom: CGFloat
//            let calculatedTo: CGFloat
//            if additive {
//                calculatedFrom = fromScale - currentScale
//                calculatedTo = 0.0
//            } else {
//                calculatedFrom = fromScale
//                calculatedTo = currentScale
//            }
//            node.layer.animateScale(from: calculatedFrom, to: calculatedTo, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, additive: additive, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func animateTransformScale(node: ASDisplayNode, from fromScale: CGPoint, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let calculatedFrom: CGPoint
//            let calculatedTo: CGPoint
//
//            calculatedFrom = fromScale
//            calculatedTo = CGPoint(x: 1.0, y: 1.0)
//
//            node.layer.animateScaleX(from: calculatedFrom.x, to: calculatedTo.x, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//            node.layer.animateScaleY(from: calculatedFrom.y, to: calculatedTo.y, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction)
//        }
//    }
//
//    func animateTransformScale(layer: CALayer, from fromScale: CGPoint, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let calculatedFrom: CGPoint
//            let calculatedTo: CGPoint
//
//            calculatedFrom = fromScale
//            calculatedTo = CGPoint(x: 1.0, y: 1.0)
//
//            layer.animateScaleX(from: calculatedFrom.x, to: calculatedTo.x, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//            layer.animateScaleY(from: calculatedFrom.y, to: calculatedTo.y, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction)
//        }
//    }
//
//    func animateTransformScale(view: UIView, from fromScale: CGFloat, completion: ((Bool) -> Void)? = nil) {
//        let t = view.layer.transform
//        let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        if currentScale.isEqual(to: fromScale) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            view.layer.animateScale(from: fromScale, to: currentScale, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateTransform(node: ASDisplayNode, transform: CGAffineTransform, beginWithCurrentState: Bool = false, delay: Double = 0.0, completion: ((Bool) -> Void)? = nil) {
//        let transform = CATransform3DMakeAffineTransform(transform)
//
//        if CATransform3DEqualToTransform(node.layer.transform, transform) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.layer.transform = transform
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousTransform: CATransform3D
//            if beginWithCurrentState, let presentation = node.layer.presentation() {
//                previousTransform = presentation.transform
//            } else {
//                previousTransform = node.layer.transform
//            }
//            node.layer.transform = transform
//            node.layer.animate(from: NSValue(caTransform3D: previousTransform), to: NSValue(caTransform3D: transform), keyPath: "transform", timingFunction: curve.timingFunction, duration: duration, mediaTimingFunction: curve.mediaTimingFunction, completion: { value in
//                completion?(value)
//            })
//        }
//    }
//
//    func updateTransformScale(node: ASDisplayNode, scale: CGFloat, beginWithCurrentState: Bool = false, delay: Double = 0.0, completion: ((Bool) -> Void)? = nil) {
//        let t = node.layer.transform
//        let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        if currentScale.isEqual(to: scale) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousScale: CGFloat
//            if beginWithCurrentState, let presentation = node.layer.presentation() {
//                let t = presentation.transform
//                previousScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//            } else {
//                previousScale = currentScale
//            }
//            node.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
//            node.layer.animateScale(from: previousScale, to: scale, duration: duration, delay: delay, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateTransformScale(layer: CALayer, scale: CGFloat, completion: ((Bool) -> Void)? = nil) {
//        let t = layer.transform
//        let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        if currentScale.isEqual(to: scale) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
//            layer.animateScale(from: currentScale, to: scale, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateSublayerTransformScale(node: ASDisplayNode, scale: CGFloat, delay: Double = 0.0, completion: ((Bool) -> Void)? = nil) {
//        if !node.isNodeLoaded {
//            node.subnodeTransform = CATransform3DMakeScale(scale, scale, 1.0)
//            completion?(true)
//            return
//        }
//        let t = node.layer.sublayerTransform
//        let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        if currentScale.isEqual(to: scale) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.layer.sublayerTransform = CATransform3DMakeScale(scale, scale, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            node.layer.sublayerTransform = CATransform3DMakeScale(scale, scale, 1.0)
//            node.layer.animate(from: NSValue(caTransform3D: t), to: NSValue(caTransform3D: node.layer.sublayerTransform), keyPath: "sublayerTransform", timingFunction: curve.timingFunction, duration: duration, delay: delay, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: true, additive: false, completion: {
//                result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateSublayerTransformScaleAdditive(node: ASDisplayNode, scale: CGFloat, completion: ((Bool) -> Void)? = nil) {
//        if !node.isNodeLoaded {
//            node.subnodeTransform = CATransform3DMakeScale(scale, scale, 1.0)
//            completion?(true)
//            return
//        }
//        let t = node.layer.sublayerTransform
//        let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        if currentScale.isEqual(to: scale) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.layer.sublayerTransform = CATransform3DMakeScale(scale, scale, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let t = node.layer.sublayerTransform
//            let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//            node.layer.sublayerTransform = CATransform3DMakeScale(scale, scale, 1.0)
//            node.layer.animate(from: -(scale - currentScale) as NSNumber, to: 0.0 as NSNumber, keyPath: "sublayerTransform.scale", timingFunction: curve.timingFunction, duration: duration, delay: 0.0, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: true, additive: true, completion: {
//                result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateSublayerTransformScaleAndOffset(node: ASDisplayNode, scale: CGFloat, offset: CGPoint, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if !node.isNodeLoaded {
//            node.subnodeTransform = CATransform3DMakeScale(scale, scale, 1.0)
//            completion?(true)
//            return
//        }
//        let t = node.layer.sublayerTransform
//        let currentScale = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        let currentOffset = CGPoint(x: t.m41 / currentScale, y: t.m42 / currentScale)
//        if abs(currentScale - scale) <= CGFloat.ulpOfOne && abs(currentOffset.x - offset.x) <= CGFloat.ulpOfOne && abs(currentOffset.y - offset.y) <= CGFloat.ulpOfOne {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        let transform = CATransform3DTranslate(CATransform3DMakeScale(scale, scale, 1.0), offset.x, offset.y, 0.0)
//
//        switch self {
//        case .immediate:
//            node.layer.sublayerTransform = transform
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let initialTransform: CATransform3D
//            if beginWithCurrentState, node.isNodeLoaded {
//                initialTransform = node.layer.presentation()?.sublayerTransform ?? t
//            } else {
//                initialTransform = t
//            }
//
//            node.layer.sublayerTransform = transform
//            node.layer.animate(from: NSValue(caTransform3D: initialTransform), to: NSValue(caTransform3D: node.layer.sublayerTransform), keyPath: "sublayerTransform", timingFunction: curve.timingFunction, duration: duration, delay: 0.0, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: true, additive: false, completion: {
//                result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateSublayerTransformScale(node: ASDisplayNode, scale: CGPoint, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        if !node.isNodeLoaded {
//            node.subnodeTransform = CATransform3DMakeScale(scale.x, scale.y, 1.0)
//            completion?(true)
//            return
//        }
//        self.updateSublayerTransformScale(layer: node.layer, scale: scale, beginWithCurrentState: beginWithCurrentState, completion: completion)
//    }
//
//    func updateSublayerTransformScale(layer: CALayer, scale: CGPoint, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        let t = layer.sublayerTransform
//        let currentScaleX = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        var currentScaleY = sqrt((t.m21 * t.m21) + (t.m22 * t.m22) + (t.m23 * t.m23))
//        if t.m22 < 0.0 {
//            currentScaleY = -currentScaleY
//        }
//        if CGPoint(x: currentScaleX, y: currentScaleY) == scale {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            layer.sublayerTransform = CATransform3DMakeScale(scale.x, scale.y, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let initialTransform: CATransform3D
//            if beginWithCurrentState {
//                initialTransform = layer.presentation()?.sublayerTransform ?? t
//            } else {
//                initialTransform = t
//            }
//
//            layer.sublayerTransform = CATransform3DMakeScale(scale.x, scale.y, 1.0)
//            layer.animate(from: NSValue(caTransform3D: initialTransform), to: NSValue(caTransform3D: layer.sublayerTransform), keyPath: "sublayerTransform", timingFunction: curve.timingFunction, duration: duration, delay: 0.0, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: true, additive: false, completion: {
//                result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateTransformScale(node: ASDisplayNode, scale: CGPoint, completion: ((Bool) -> Void)? = nil) {
//        if !node.isNodeLoaded {
//            node.subnodeTransform = CATransform3DMakeScale(scale.x, scale.y, 1.0)
//            completion?(true)
//            return
//        }
//
//        self.updateTransformScale(layer: node.layer, scale: scale, completion: completion)
//    }
//
//    func updateTransformScale(layer: CALayer, scale: CGPoint, completion: ((Bool) -> Void)? = nil) {
//        let t = layer.transform
//        let currentScaleX = sqrt((t.m11 * t.m11) + (t.m12 * t.m12) + (t.m13 * t.m13))
//        var currentScaleY = sqrt((t.m21 * t.m21) + (t.m22 * t.m22) + (t.m23 * t.m23))
//        if t.m22 < 0.0 {
//            currentScaleY = -currentScaleY
//        }
//        if CGPoint(x: currentScaleX, y: currentScaleY) == scale {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            layer.transform = CATransform3DMakeScale(scale.x, scale.y, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            layer.transform = CATransform3DMakeScale(scale.x, scale.y, 1.0)
//            layer.animate(from: NSValue(caTransform3D: t), to: NSValue(caTransform3D: layer.transform), keyPath: "transform", timingFunction: curve.timingFunction, duration: duration, delay: 0.0, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: true, additive: false, completion: {
//                result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateSublayerTransformOffset(layer: CALayer, offset: CGPoint, completion: ((Bool) -> Void)? = nil) {
//        let t = layer.sublayerTransform
//        let currentOffset = CGPoint(x: t.m41, y: t.m42)
//        if currentOffset == offset {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            layer.sublayerTransform = CATransform3DMakeTranslation(offset.x, offset.y, 0.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            layer.sublayerTransform = CATransform3DMakeTranslation(offset.x, offset.y, 0.0)
//            layer.animate(from: NSValue(caTransform3D: t), to: NSValue(caTransform3D: layer.sublayerTransform), keyPath: "sublayerTransform", timingFunction: curve.timingFunction, duration: duration, delay: 0.0, mediaTimingFunction: curve.mediaTimingFunction, removeOnCompletion: true, additive: false, completion: {
//                result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateTransformRotation(node: ASDisplayNode, angle: CGFloat, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        let t = node.layer.transform
//        let currentAngle = atan2(t.m12, t.m11)
//        if currentAngle.isEqual(to: angle) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            node.layer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousAngle: CGFloat
//            if beginWithCurrentState, let presentation = node.layer.presentation() {
//                let t = presentation.transform
//                previousAngle = atan2(t.m12, t.m11)
//            } else {
//                previousAngle = currentAngle
//            }
//            node.layer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
//            node.layer.animateRotation(from: previousAngle, to: angle, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateTransformRotation(view: UIView, angle: CGFloat, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        let t = view.layer.transform
//        let currentAngle = atan2(t.m12, t.m11)
//        if currentAngle.isEqual(to: angle) {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            view.layer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousAngle: CGFloat
//            if beginWithCurrentState, let presentation = view.layer.presentation() {
//                let t = presentation.transform
//                previousAngle = atan2(t.m12, t.m11)
//            } else {
//                previousAngle = currentAngle
//            }
//            view.layer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
//            view.layer.animateRotation(from: previousAngle, to: angle, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//
//    func updateTransformRotationAndScale(view: UIView, angle: CGFloat, scale: CGPoint, beginWithCurrentState: Bool = false, completion: ((Bool) -> Void)? = nil) {
//        let t = view.layer.transform
//        let currentAngle = atan2(t.m12, t.m11)
//        let currentScale = CGPoint(x: t.m11, y: t.m12)
//        if currentAngle.isEqual(to: angle) && currentScale == scale {
//            if let completion = completion {
//                completion(true)
//            }
//            return
//        }
//
//        switch self {
//        case .immediate:
//            view.layer.transform = CATransform3DRotate(CATransform3DMakeScale(scale.x, scale.y, 1.0), angle, 0.0, 0.0, 1.0)
//            if let completion = completion {
//                completion(true)
//            }
//        case let .animated(duration, curve):
//            let previousAngle: CGFloat
//            if beginWithCurrentState, let presentation = view.layer.presentation() {
//                let t = presentation.transform
//                previousAngle = atan2(t.m12, t.m11)
//            } else {
//                previousAngle = currentAngle
//            }
//            view.layer.transform = CATransform3DRotate(CATransform3DMakeScale(scale.x, scale.y, 1.0), angle, 0.0, 0.0, 1.0)
//            view.layer.animateRotation(from: previousAngle, to: angle, duration: duration, timingFunction: curve.timingFunction, mediaTimingFunction: curve.mediaTimingFunction, completion: { result in
//                if let completion = completion {
//                    completion(result)
//                }
//            })
//        }
//    }
//}
//
//public struct CombinedTransition {
//    public var horizontal: ContainedViewLayoutTransition
//    public var vertical: ContainedViewLayoutTransition
//
//    public var isAnimated: Bool {
//        return self.horizontal.isAnimated || self.vertical.isAnimated
//    }
//
//    public init(horizontal: ContainedViewLayoutTransition, vertical: ContainedViewLayoutTransition) {
//        self.horizontal = horizontal
//        self.vertical = vertical
//    }
//
//    public func animateFrame(layer: CALayer, from fromFrame: CGRect, completion: ((Bool) -> Void)? = nil) {
//        //self.horizontal.animateFrame(layer: layer, from: fromFrame, completion: completion)
//        //return;
//        let toFrame = layer.frame
//
//        enum Keys: CaseIterable {
//            case positionX, positionY
//            case sizeWidth, sizeHeight
//        }
//        var remainingKeys = Keys.allCases
//        var completedValue = true
//        let completeKey: (Keys, Bool) -> Void = { key, completed in
//            remainingKeys.removeAll(where: { $0 == key })
//            if !completed {
//                completedValue = false
//            }
//            if remainingKeys.isEmpty {
//                completion?(completedValue)
//            }
//        }
//
//        self.horizontal.animatePositionAdditive(layer: layer, offset: CGPoint(x: fromFrame.midX - toFrame.midX, y: 0.0), completion: { result in
//            completeKey(.positionX, result)
//        })
//        self.vertical.animatePositionAdditive(layer: layer, offset: CGPoint(x: 0.0, y: fromFrame.midY - toFrame.midY), completion: { result in
//            completeKey(.positionY, result)
//        })
//
//        self.horizontal.animateWidthAdditive(layer: layer, value: fromFrame.width - toFrame.width, completion: { result in
//            completeKey(.sizeWidth, result)
//        })
//        self.vertical.animateHeightAdditive(layer: layer, value: fromFrame.height - toFrame.height, completion: { result in
//            completeKey(.sizeHeight, result)
//        })
//    }
//
//    public func updateFrame(layer: CALayer, frame: CGRect, completion: ((Bool) -> Void)? = nil) {
//        let fromFrame = layer.frame
//        layer.frame = frame
//        self.animateFrame(layer: layer, from: fromFrame, completion: completion)
//    }
//
//    public func updateFrame(node: ASDisplayNode, frame: CGRect, completion: ((Bool) -> Void)? = nil) {
//        let fromFrame = node.frame
//        node.frame = frame
//        self.animateFrame(layer: node.layer, from: fromFrame, completion: completion)
//    }
//
//    public func updatePosition(layer: CALayer, position: CGPoint, completion: ((Bool) -> Void)? = nil) {
//        let fromPosition = layer.position
//        layer.position = position
//
//        enum Keys: CaseIterable {
//            case positionX, positionY
//        }
//        var remainingKeys = Keys.allCases
//        var completedValue = true
//        let completeKey: (Keys, Bool) -> Void = { key, completed in
//            remainingKeys.removeAll(where: { $0 == key })
//            if !completed {
//                completedValue = false
//            }
//            if remainingKeys.isEmpty {
//                completion?(completedValue)
//            }
//        }
//
//        self.horizontal.animatePositionAdditive(layer: layer, offset: CGPoint(x: fromPosition.x - position.x, y: 0.0), completion: { result in
//            completeKey(.positionX, result)
//        })
//        self.vertical.animatePositionAdditive(layer: layer, offset: CGPoint(x: 0.0, y: fromPosition.y - position.y), completion: { result in
//            completeKey(.positionY, result)
//        })
//    }
//
//    public func animatePositionAdditive(layer: CALayer, offset: CGPoint, to toOffset: CGPoint = CGPoint(), removeOnCompletion: Bool = true, completion: ((Bool) -> Void)? = nil) {
//        enum Keys: CaseIterable {
//            case positionX, positionY
//        }
//        var remainingKeys = Keys.allCases
//        var completedValue = true
//        let completeKey: (Keys, Bool) -> Void = { key, completed in
//            remainingKeys.removeAll(where: { $0 == key })
//            if !completed {
//                completedValue = false
//            }
//            if remainingKeys.isEmpty {
//                completion?(completedValue)
//            }
//        }
//
//        self.horizontal.animatePositionAdditive(layer: layer, offset: CGPoint(x: offset.x, y: 0.0), to: CGPoint(x: toOffset.x, y: 0.0), completion: { result in
//            completeKey(.positionX, result)
//        })
//        self.vertical.animatePositionAdditive(layer: layer, offset: CGPoint(x: 0.0, y: offset.y), to: CGPoint(x: 0.0, y: toOffset.y), completion: { result in
//            completeKey(.positionY, result)
//        })
//    }
//}
//
//public extension ContainedViewLayoutTransition {
//    func animateView(_ f: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
//        switch self {
//        case .immediate:
//            f()
//            completion?(true)
//        case let .animated(duration, curve):
//            UIView.animate(withDuration: duration, delay: 0.0, options: curve.viewAnimationOptions, animations: {
//                f()
//            }, completion: completion)
//        }
//    }
//}
