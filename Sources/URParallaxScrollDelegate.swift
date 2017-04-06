//
//  URParallaxScrollDelegate.swift
//  URParallaxScrollAnimator
//
//  Created by DongSoo Lee on 2017. 4. 6..
//
//

import UIKit

public protocol URParallaxScrollDelegate: class {

    var preOffsetY: CGFloat { get set }
    var preOffsetY1: CGFloat { get set }

    func initScroll()

    var isHapticFeedbackEnabled: Bool { get set }

    func generateHapticFeedback()

    func parallaxScrollViewDidScroll(_ scrollView: UIScrollView)

    func parallaxScrollViewWillBeginDragging()

    func parallaxScrollViewDidEndDragging()
}

extension URParallaxScrollDelegate where Self: URParallaxScrollAnimatorMakable, Self: URParallaxScrollAnimatable {

    func initScroll() {
        // init values
        self.configuration.parallaxScrollRatio = DefaultParallaxScrollRatio

        // init scroll position
        self.preOffsetY1 = (-self.upperImageView.bounds.height) * self.configuration.parallaxScrollRatio / DefaultParallaxScrollRatio
        self.lowerScrollView.contentOffset = CGPoint(x: self.lowerScrollView.contentOffset.x, y: self.preOffsetY1)

        self.isHapticFeedbackEnabled = true
    }

    fileprivate func generateHapticFeedback() {
        if self.isHapticFeedbackEnabled {
            if #available(iOS 10.0, *) {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
        }
    }

    func parallaxScrollViewDidScroll(_ scrollView: UIScrollView) {

        //        let scrollDirection: URScrollVerticalDirection = self.preOffsetY > scrollView.contentOffset.y ? .down : .up

        let scrollRatio: CGFloat = self.upperScrollView.contentSize.height / scrollView.contentSize.height * self.configuration.parallaxScrollRatio
        let limitImageScrollOffsetY: CGFloat = self.upperImageView.bounds.height + abs(scrollView.contentOffset.y * scrollRatio)

        let scrollRatio1: CGFloat = self.lowerScrollView.contentSize.height / scrollView.contentSize.height * self.configuration.lowerParallaxScrollRatio

        let progress: CGFloat = abs(scrollView.contentOffset.y) / limitImageScrollOffsetY
        if limitImageScrollOffsetY > abs(scrollView.contentOffset.y) {
            self.upperScrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y * scrollRatio)
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.preOffsetY1 + (scrollView.contentOffset.y * scrollRatio1 * -1))

            self.generateHapticFeedback()

            self.animateRefreshImage(progress: progress, parallaxScrollType: self.configuration.parallaxScrollType)
        } else {
            self.isHapticFeedbackEnabled = false

            self.animateRefreshImage(progress: 1.0, parallaxScrollType: self.configuration.parallaxScrollType)

            self.upperScrollView.contentOffset = CGPoint(x: 0, y: self.upperScrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetY))
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.lowerScrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetY))
        }

        self.preOffsetY = scrollView.contentOffset.y

        if scrollView.contentOffset.y == 0 {
            self.initScroll()
        }
    }

    func parallaxScrollViewWillBeginDragging() {
        self.isHapticFeedbackEnabled = true
    }

    func parallaxScrollViewDidEndDragging() {
        self.isHapticFeedbackEnabled = false
        
        self.animateRefreshImage(progress: 0.0, parallaxScrollType: self.configuration.parallaxScrollType)
    }
}
