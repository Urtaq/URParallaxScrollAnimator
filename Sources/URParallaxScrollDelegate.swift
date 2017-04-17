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

    @available(iOS 10.0, *)
    var hapticFeedbackGenerator: NSObject? { get set }
    func generateHapticFeedback()

    func parallaxScrollViewDidScroll(_ scrollView: UIScrollView)

    func parallaxScrollViewWillBeginDragging(_ scrollView: UIScrollView)

    func parallaxScrollViewDidEndDragging(_ scrollView: UIScrollView)

    func parallaxScrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)

    /// must call, just after the pull to refresh is finished
    func parallaxScrollViewDidPullToRefresh()
}

extension URParallaxScrollDelegate where Self: URParallaxScrollAnimatorMakable, Self: URParallaxScrollAnimatable {

    public func initScroll() {
        // init values

        // init scroll position
        self.preOffsetYLower = (-self.upperImageView.bounds.height) * self.configuration.parallaxScrollRatio / URParallaxScrollConfiguration.DefaultParallaxScrollRatio
        self.lowerScrollView.contentOffset = CGPoint(x: self.lowerScrollView.contentOffset.x, y: self.preOffsetYLower)

        self.isTriggeredRefresh = false
        self.isHapticFeedbackEnabled = true
    }

    public func prepareHapticFeedback() {
        if #available(iOS 10.0, *) {
            self.hapticFeedbackGenerator = UISelectionFeedbackGenerator()
            (self.hapticFeedbackGenerator as? UISelectionFeedbackGenerator)?.prepare()
        }
    }

    public func generateHapticFeedback() {
        if self.isHapticFeedbackEnabled {
            if #available(iOS 10.0, *) {
                (self.hapticFeedbackGenerator as? UISelectionFeedbackGenerator)?.selectionChanged()
            }
        }
    }

    public func parallaxScrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.startOffsetY == 0.0 && scrollView.contentOffset.y > 0 {
            self.startOffsetY = scrollView.contentOffset.y
        }

//        let scrollDirection: URParallaxScrollVerticalDirection = (self.preOffsetYUpper > scrollView.contentOffset.y && scrollView.contentOffset.y < 0) ? .down : .up

        let scrollRatio: CGFloat = self.upperImageView.bounds.height / scrollView.bounds.height * self.configuration.parallaxScrollRatio
        let limitImageScrollOffsetY: CGFloat = self.upperImageView.bounds.height / (1 - self.upperImageView.bounds.height / scrollView.bounds.height * self.configuration.parallaxScrollRatio)

        let progress: CGFloat = abs(scrollView.contentOffset.y) / limitImageScrollOffsetY
        if limitImageScrollOffsetY >= abs(scrollView.contentOffset.y) {
            var animationProgress: CGFloat = progress
            if self.isPullToRefreshEnabled {
                if self.isTriggeredRefresh && self.isGestureReleased && self.startOffsetY <= 0 {
                    // prevent to be back...
                    scrollView.setContentOffset(CGPoint(x: 0, y: limitImageScrollOffsetY * -1), animated: false)

                    if scrollView.contentInset.top == 0 {
                        scrollView.contentInset.top = limitImageScrollOffsetY

                        guard let release = self.refreshAction else { return }
                        DispatchQueue.main.async(execute: release)
                    }
                    
                    animationProgress = -1.0
                }
            }

            self.upperScrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y * scrollRatio)
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.preOffsetYLower + self.preOffsetYLower * progress * -1 + scrollView.contentOffset.y * scrollRatio)

            self.generateHapticFeedback()

            self.animateRefreshImage(progress: animationProgress, parallaxScrollType: self.configuration.parallaxScrollType)
        } else {
            self.isHapticFeedbackEnabled = false

            var animationProgress: CGFloat = 1.0
            if self.isPullToRefreshEnabled {
                if self.isTriggeredRefresh && self.isGestureReleased {
                    animationProgress = -1.0
                }
            }

            self.animateRefreshImage(progress: animationProgress, parallaxScrollType: self.configuration.parallaxScrollType)

            self.upperScrollView.contentOffset = CGPoint(x: 0, y: self.upperScrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetYUpper))
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.lowerScrollView.contentOffset.y + (scrollView.contentOffset.y - self.preOffsetYUpper))
        }

        self.preOffsetYUpper = scrollView.contentOffset.y

        if scrollView.contentOffset.y == 0 {
            self.initScroll()
        }
    }

    public func parallaxScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startOffsetY = 0.0

        self.isHapticFeedbackEnabled = true
        self.prepareHapticFeedback()
        self.isGestureReleased = false

        scrollView.backgroundColor = UIColor.clear

        if scrollView.contentOffset.y == 0 {
            self.initScroll()
        }
    }

    public func parallaxScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        self.startOffsetY = 0.0
        self.isHapticFeedbackEnabled = false
        if #available(iOS 10.0, *) {
            self.hapticFeedbackGenerator = nil
        }
        self.isGestureReleased = true
        
        self.animateRefreshImage(progress: 0.0, parallaxScrollType: self.configuration.parallaxScrollType)

        if self.isPullToRefreshEnabled {
            let limitImageScrollOffsetY: CGFloat = self.upperImageView.bounds.height / (1 - self.upperImageView.bounds.height / scrollView.bounds.height * self.configuration.parallaxScrollRatio)
            if limitImageScrollOffsetY >= abs(scrollView.contentOffset.y) {
                self.isTriggeredRefresh = false
            } else {
                self.isTriggeredRefresh = true
            }
        }
    }

    public func parallaxScrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            self.target.backgroundColor = self.targetBackgroundColor
        }
    }

    public func parallaxScrollViewDidPullToRefresh() {
        if self.isPullToRefreshEnabled {
            if self.isTriggeredRefresh {
                self.isTriggeredRefresh = false
                if self.target.contentInset.top != 0 {
                    let insetTop: CGFloat = self.target.contentInset.top
                    self.target.contentInset.top = 0
                    self.target.setContentOffset(CGPoint(x: 0, y: insetTop * -1), animated: false)
                    self.target.setContentOffset(CGPoint.zero, animated: true)
                }
            }
        }
    }
}
