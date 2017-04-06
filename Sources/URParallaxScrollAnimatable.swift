//
//  URParallaxScrollAnimatable.swift
//  URParallaxScrollAnimator
//
//  Created by DongSoo Lee on 2017. 4. 6..
//
//

import Foundation
import Lottie

public protocol URParallaxScrollAnimatable: class {
    var upperLotAnimationView: LOTAnimationView! { get set }
    var lowerLotAnimationView: LOTAnimationView! { get set }

    func animateRefreshImage(progress: CGFloat, parallaxScrollType: URParallaxScrollAnimationType)
}

extension URParallaxScrollAnimatable where Self: URParallaxScrollAnimatorMakable {

    public func initLotAnimationView(position: URParallaxScrollViewPosition, data: String) {
        switch position {
        case .upper:
            self.upperLotAnimationView = LOTAnimationView(name: data)
        case .lower:
            self.lowerLotAnimationView = LOTAnimationView(name: data)
        default:
            break
        }
    }

    public func animateRefreshImage(progress: CGFloat, parallaxScrollType: URParallaxScrollAnimationType) {
        switch parallaxScrollType {
        case .upperLayer:
            self.upperLotAnimationView.animationProgress = progress
        case .lowerLayer:
            self.lowerLotAnimationView.animationProgress = progress
        default:
            self.upperLotAnimationView.animationProgress = progress
            self.lowerLotAnimationView.animationProgress = progress
        }
    }
}
