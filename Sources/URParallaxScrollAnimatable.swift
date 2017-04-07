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

    public func animateRefreshImage(progress: CGFloat = -1.0, parallaxScrollType: URParallaxScrollAnimationType) {
        switch parallaxScrollType {
        case .upperLayer:
            if self.upperLotAnimationView != nil {
                if progress < 0.0 {
                    self.upperLotAnimationView.loopAnimation = true
                    self.upperLotAnimationView.animationSpeed = 2.0
                    self.upperLotAnimationView.play()
                } else {
                    self.upperLotAnimationView.animationProgress = progress
                }
            }
        case .lowerLayer:
            if self.lowerLotAnimationView != nil {
                if progress < 0.0 {
                    self.lowerLotAnimationView.loopAnimation = true
                    self.lowerLotAnimationView.animationSpeed = 2.0
                    self.lowerLotAnimationView.play()
                } else {
                    self.lowerLotAnimationView.animationProgress = progress
                }
            }
        default:
            if self.upperLotAnimationView != nil {
                if progress < 0.0 {
                    self.upperLotAnimationView.loopAnimation = true
                    self.upperLotAnimationView.animationSpeed = 2.0
                    self.upperLotAnimationView.play()
                } else {
                    self.upperLotAnimationView.animationProgress = progress
                }
            }
            if self.lowerLotAnimationView != nil {

                if progress < 0.0 {
                    self.lowerLotAnimationView.loopAnimation = true
                    self.lowerLotAnimationView.animationSpeed = 2.0
                    self.lowerLotAnimationView.play()
                } else {
                    self.lowerLotAnimationView.animationProgress = progress
                }
            }
        }
    }
}
