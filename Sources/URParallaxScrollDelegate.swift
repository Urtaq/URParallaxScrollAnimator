//
//  URParallaxScrollDelegate.swift
//  URParallaxScrollAnimator
//
//  Created by DongSoo Lee on 2017. 4. 6..
//
//

import UIKit

public protocol URParallaxScrollDelegate: class {
//    var delegateParallaxScroll: URParallaxScrollDelegate! { get set }

    var startOffsetY: CGFloat { get set }
    var preOffsetYUpper: CGFloat { get set }
    var preOffsetYLower: CGFloat { get set }
    var isGestureReleased: Bool { get set }

    func initScroll()

    var isHapticFeedbackEnabled: Bool { get set }

    func generateHapticFeedback()

    func parallaxScrollViewDidScroll(_ scrollView: UIScrollView)

    func parallaxScrollViewWillBeginDragging(_ scrollView: UIScrollView)

    func parallaxScrollViewDidEndDragging(_ scrollView: UIScrollView)

    /// must call, just after the pull to refresh is finished
    func parallaxScrollViewDidPullToRefresh()
}

extension URParallaxScrollDelegate where Self: URParallaxScrollAnimatorMakable, Self: URParallaxScrollAnimatable {

    public func initScroll() {
        // init values
        self.configuration.parallaxScrollRatio = self.configuration.parallaxScrollRatio
        // init scroll position
        self.preOffsetYLower = (-self.upperImageView.bounds.height) * self.configuration.parallaxScrollRatio / URParallaxScrollConfiguration.DefaultParallaxScrollRatio
        self.lowerScrollView.contentOffset = CGPoint(x: self.lowerScrollView.contentOffset.x, y: self.preOffsetYLower)

        self.isTriggeredRefresh = false
        self.isHapticFeedbackEnabled = true
    }

    public func generateHapticFeedback() {
        if self.isHapticFeedbackEnabled {
            if #available(iOS 10.0, *) {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
        }
    }

    public func parallaxScrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#function)
        print("scrollView is \(scrollView.contentOffset.y)")
        if self.startOffsetY == 0.0 && scrollView.contentOffset.y > 0 {
            self.startOffsetY = scrollView.contentOffset.y
            print("self.startOffsetY is \(self.startOffsetY)")
        }

//        let scrollDirection: URParallaxScrollVerticalDirection = (self.preOffsetYUpper > scrollView.contentOffset.y && scrollView.contentOffset.y < 0) ? .down : .up

        let scrollRatio: CGFloat = self.upperImageView.bounds.height / scrollView.bounds.height * self.configuration.parallaxScrollRatio
        let limitImageScrollOffsetY: CGFloat = self.upperImageView.bounds.height + abs(scrollView.contentOffset.y * scrollRatio)

        let progress: CGFloat = abs(scrollView.contentOffset.y) / limitImageScrollOffsetY
        if limitImageScrollOffsetY >= abs(scrollView.contentOffset.y) {
            print("in limit")
            var animationProgress: CGFloat = progress
            if self.isTriggeredRefresh && self.isGestureReleased {
                // prevent to be back...
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: true)

                animationProgress = -1.0

                guard let release = self.refreshAction else { return }
                DispatchQueue.main.async(execute: release)
            }

            self.upperScrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y * scrollRatio)
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.preOffsetYLower + self.preOffsetYLower * progress * -1 + scrollView.contentOffset.y * scrollRatio)

            self.generateHapticFeedback()

            self.animateRefreshImage(progress: animationProgress, parallaxScrollType: self.configuration.parallaxScrollType)
        } else {
            print("out of limit")
            if self.startOffsetY <= 0.0 {
                self.isTriggeredRefresh = true
            } else {
                self.isTriggeredRefresh = false
            }
            self.isHapticFeedbackEnabled = false

            self.animateRefreshImage(progress: 1.0, parallaxScrollType: self.configuration.parallaxScrollType)

            self.upperScrollView.contentOffset = CGPoint(x: 0, y: self.upperScrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetYUpper))
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.lowerScrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetYUpper))
        }

        self.preOffsetYUpper = scrollView.contentOffset.y

        if scrollView.contentOffset.y == 0 {
            self.initScroll()
        }
    }

    public func parallaxScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function)
        self.isHapticFeedbackEnabled = true
        self.isGestureReleased = false

        if scrollView.contentOffset.y == 0 {
            self.initScroll()
        }
    }

    public func parallaxScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        print(#function)
        self.startOffsetY = 0.0
        self.isHapticFeedbackEnabled = false
        self.isGestureReleased = true
        
        self.animateRefreshImage(progress: 0.0, parallaxScrollType: self.configuration.parallaxScrollType)

        let scrollRatio: CGFloat = self.upperImageView.bounds.height / scrollView.bounds.height * self.configuration.parallaxScrollRatio
        let limitImageScrollOffsetY: CGFloat = self.upperImageView.bounds.height + abs(scrollView.contentOffset.y * scrollRatio)
        if limitImageScrollOffsetY >= abs(scrollView.contentOffset.y) {
            self.isTriggeredRefresh = false
        } else {
            self.isTriggeredRefresh = true
        }
    }

    public func parallaxScrollViewDidPullToRefresh() {
        if isTriggeredRefresh {
            self.isTriggeredRefresh = false
            self.target.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
