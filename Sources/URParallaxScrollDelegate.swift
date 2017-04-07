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

    var preOffsetY: CGFloat { get set }
    var preOffsetY1: CGFloat { get set }

    func initScroll()

    var isHapticFeedbackEnabled: Bool { get set }

    func generateHapticFeedback()

    func parallaxScrollViewDidScroll(_ scrollView: UIScrollView)

    func parallaxScrollViewWillBeginDragging(_ scrollView: UIScrollView)

    func parallaxScrollViewDidEndDragging(releaseAction: (() -> Void)?)

    /// must call, just after the pull to refresh is finished
    func parallaxScrollViewDidPullToRefresh()
}

extension URParallaxScrollDelegate where Self: URParallaxScrollAnimatorMakable, Self: URParallaxScrollAnimatable {

    public func initScroll() {
        // init values
        self.configuration.parallaxScrollRatio = self.configuration.parallaxScrollRatio
        // init scroll position
        self.preOffsetY1 = (-self.upperImageView.bounds.height) * self.configuration.parallaxScrollRatio / URParallaxScrollConfiguration.DefaultParallaxScrollRatio
        self.lowerScrollView.contentOffset = CGPoint(x: self.lowerScrollView.contentOffset.x, y: self.preOffsetY1)

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

//        let scrollDirection: URScrollVerticalDirection = self.preOffsetY > scrollView.contentOffset.y ? .down : .up

        let scrollRatio: CGFloat = self.upperScrollView.contentSize.height / scrollView.bounds.height * self.configuration.parallaxScrollRatio
        let limitImageScrollOffsetY: CGFloat = self.upperImageView.bounds.height + abs(scrollView.contentOffset.y * scrollRatio)

        let progress: CGFloat = abs(scrollView.contentOffset.y) / limitImageScrollOffsetY
        if limitImageScrollOffsetY >= abs(scrollView.contentOffset.y) {
            if self.isTriggeredRefresh {
                // prevent to be back...
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: true)
            }

            self.upperScrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y * scrollRatio)
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.preOffsetY1 + self.preOffsetY1 * progress * -1 + scrollView.contentOffset.y * scrollRatio)

            self.generateHapticFeedback()

            self.animateRefreshImage(progress: progress, parallaxScrollType: self.configuration.parallaxScrollType)
        } else {
            self.isTriggeredRefresh = true
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

    public func parallaxScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isHapticFeedbackEnabled = true

        if scrollView.contentOffset.y == 0 {
            self.initScroll()
        }
    }

    public func parallaxScrollViewDidEndDragging(releaseAction: (() -> Void)? = nil) {
        self.isHapticFeedbackEnabled = false
        
        self.animateRefreshImage(progress: 0.0, parallaxScrollType: self.configuration.parallaxScrollType)

        if self.isTriggeredRefresh {
            guard let release = releaseAction else { return }
            DispatchQueue.main.async(execute: release)
        }
    }

    public func parallaxScrollViewDidPullToRefresh() {
        self.isTriggeredRefresh = false
        self.target.setContentOffset(CGPoint.zero, animated: true)
    }
}
