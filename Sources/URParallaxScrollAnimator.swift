//
//  URParallaxScrollAnimator.swift
//  URParallaxScrollAnimator
//
//  Created by DongSoo Lee on 2017. 4. 5..
//
//

import UIKit
import Lottie

let DefaultParallaxScrollRatio: CGFloat = 1.38
let DefaultBackgroundColor: UIColor = UIColor(red: 1.0, green: 0xae / 0xff, blue: 0.0, alpha: 1.0)

public enum URParallaxScrollAnimationType {
    case upperLayer
    case lowerLayer
    case both
}

public struct URParallaxScrollConfiguration {
    var parallaxScrollRatio: CGFloat = DefaultParallaxScrollRatio

    var lowerParallaxScrollRatio: CGFloat {
        return self.parallaxScrollRatio * DefaultParallaxScrollRatio * 1.5
    }

    var parallaxScrollType: URParallaxScrollAnimationType = .both

    var backgroundColor: UIColor = DefaultBackgroundColor

    var upperImage: UIImage!
    var lowerImage: UIImage!

    init(parallaxScrollRatio: CGFloat = DefaultParallaxScrollRatio, parallaxScrollType: URParallaxScrollAnimationType = .both, backgroundColor: UIColor = DefaultBackgroundColor, upperImage: UIImage!, lowerImage: UIImage!) {
        self.parallaxScrollRatio = parallaxScrollRatio
        self.parallaxScrollType = parallaxScrollType
        self.backgroundColor = backgroundColor

        if upperImage != nil {
            self.upperImage = upperImage
        }
        if lowerImage != nil {
            self.lowerImage = lowerImage
        }
    }
}

public class URParallaxScrollExtension: NSObject, URParallaxScrollAnimatorMakable, URParallaxScrollAnimatable {

    fileprivate(set) var parallaxScrollConfiguration: URParallaxScrollConfiguration!

    fileprivate(set) var parallaxTargetTableView: UITableView

    fileprivate var upperScrollView: UIScrollView!
    fileprivate var upperImageView: UIImageView!

    fileprivate var upperLotAnimationView: LOTAnimationView!

    fileprivate var lowerScrollView: UIScrollView!
    fileprivate var lowerImageView: UIImageView!

    fileprivate var lowerLotAnimationView: LOTAnimationView!

    fileprivate init(_ base: UITableView) {
        self.parallaxTargetTableView = base
        super.init()
        self.initParallaxScrollViews()
    }
}

private protocol URParallaxScrollAnimatorMakable: class {
    var parallaxScrollConfiguration: URParallaxScrollConfiguration! { get set }

    var parallaxTargetTableView: UITableView { get set }

    var upperScrollView: UIScrollView! { get set }
    var upperImageView: UIImageView! { get set }

    var lowerScrollView: UIScrollView! { get set }
    var lowerImageView: UIImageView! { get set }

    func makeParallaxScrollExtensionConfiguration(parallaxScrollRatio: CGFloat, parallaxScrollType: URParallaxScrollAnimationType, backgroundColor: UIColor, upperImage: UIImage, lowerImage: UIImage)

    func initParallaxScrollViews()
}

extension URParallaxScrollAnimatorMakable {

    public func makeParallaxScrollExtensionConfiguration(parallaxScrollRatio: CGFloat = DefaultParallaxScrollRatio, parallaxScrollType: URParallaxScrollAnimationType = .upperLayer, backgroundColor: UIColor = DefaultBackgroundColor, upperImage: UIImage, lowerImage: UIImage) {
        self.parallaxTargetTableView.parallaxScrollExtension.parallaxScrollConfiguration = URParallaxScrollConfiguration(parallaxScrollRatio: parallaxScrollRatio, parallaxScrollType: parallaxScrollType, backgroundColor: backgroundColor, upperImage: upperImage, lowerImage: lowerImage)

        self.initParallaxScrollViews()
    }

    public func initParallaxScrollViews() {
        self.parallaxScrollConfiguration = self.parallaxTargetTableView.parallaxScrollExtension.parallaxScrollConfiguration

        guard let superview = self.parallaxTargetTableView.superview else {
            fatalError("[\(URParallaxScrollExtension.self)] This tableview needs the superview!!")
        }

        superview.insertSubview(self.upperScrollView, belowSubview: self.parallaxTargetTableView)
        superview.insertSubview(self.lowerScrollView, belowSubview: self.upperScrollView)

        self.upperScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.lowerScrollView.translatesAutoresizingMaskIntoConstraints = false

        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))

        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.parallaxTargetTableView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))

        self.upperImageView = UIImageView(image: self.parallaxTargetTableView.parallaxScrollExtension.parallaxScrollConfiguration.upperImage)
        self.upperScrollView.addSubview(self.upperImageView)

        self.lowerImageView = UIImageView(image: self.parallaxTargetTableView.parallaxScrollExtension.parallaxScrollConfiguration.lowerImage)
        self.lowerScrollView.addSubview(self.lowerImageView)
    }
}

struct AssociatedKey {
    static var extensionAddress: UInt8 = 0
}

extension UITableView {

    public var parallaxScrollExtension: URParallaxScrollExtension {
        guard let parallaxScrollEx = objc_getAssociatedObject(self, &AssociatedKey.extensionAddress) as? URParallaxScrollExtension else {
            let parallaxScrollEx: URParallaxScrollExtension = URParallaxScrollExtension(self)
            objc_setAssociatedObject(self, &AssociatedKey.extensionAddress, parallaxScrollEx, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return parallaxScrollEx
        }

        return parallaxScrollEx
    }
}

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
        self.parallaxScrollConfiguration.parallaxScrollRatio = DefaultParallaxScrollRatio

        // init scroll position
        self.preOffsetY1 = (-self.upperImageView.bounds.height) * self.parallaxScrollConfiguration.parallaxScrollRatio / DefaultParallaxScrollRatio
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

        let scrollRatio: CGFloat = self.upperScrollView.contentSize.height / scrollView.contentSize.height * self.parallaxScrollConfiguration.parallaxScrollRatio
        let limitImageScrollOffsetY: CGFloat = self.upperImageView.bounds.height + abs(scrollView.contentOffset.y * scrollRatio)

        let scrollRatio1: CGFloat = self.lowerScrollView.contentSize.height / scrollView.contentSize.height * self.parallaxScrollConfiguration.lowerParallaxScrollRatio

        let progress: CGFloat = abs(scrollView.contentOffset.y) / limitImageScrollOffsetY
        if limitImageScrollOffsetY > abs(scrollView.contentOffset.y) {
            self.upperScrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y * scrollRatio)
            self.lowerScrollView.contentOffset = CGPoint(x: 0, y: self.preOffsetY1 + (scrollView.contentOffset.y * scrollRatio1 * -1))

            self.generateHapticFeedback()

            self.animateRefreshImage(progress: progress, parallaxScrollType: self.parallaxScrollConfiguration.parallaxScrollType)
        } else {
            self.isHapticFeedbackEnabled = false

            self.animateRefreshImage(progress: 1.0, parallaxScrollType: self.parallaxScrollConfiguration.parallaxScrollType)

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

        self.animateRefreshImage(progress: 0.0, parallaxScrollType: self.parallaxScrollConfiguration.parallaxScrollType)
    }
}

fileprivate enum URScrollVerticalDirection {
    case up
    case down
}

fileprivate protocol URParallaxScrollAnimatable {
    var upperLotAnimationView: LOTAnimationView! { get set }
    var lowerLotAnimationView: LOTAnimationView! { get set }

    func animateRefreshImage(progress: CGFloat, parallaxScrollType: URParallaxScrollAnimationType)
}

extension URParallaxScrollAnimatable {

    func animateRefreshImage(progress: CGFloat, parallaxScrollType: URParallaxScrollAnimationType) {
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

// MARK:- Util
func roundUp(_ value: Double, roundUpPosition: Int) -> Double {
    let roundUpPositionBy10 = pow(10.0, Double(roundUpPosition))
    return round(value * roundUpPositionBy10) / roundUpPositionBy10
}
