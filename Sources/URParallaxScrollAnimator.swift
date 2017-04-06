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

    var upperLottieData: String!
    var lowerLottieData: String!

    init(parallaxScrollRatio: CGFloat = DefaultParallaxScrollRatio, parallaxScrollType: URParallaxScrollAnimationType = .both, backgroundColor: UIColor = DefaultBackgroundColor, upperImage: UIImage!, lowerImage: UIImage!, upperLottieData: String! = nil, lowerLottieData: String! = nil) {
        self.parallaxScrollRatio = parallaxScrollRatio
        self.parallaxScrollType = parallaxScrollType
        self.backgroundColor = backgroundColor

        self.upperImage = upperImage
        self.lowerImage = lowerImage

        self.upperLottieData = upperLottieData
        self.lowerLottieData = lowerLottieData
    }
}

public class URParallaxScrollExtension: NSObject, URParallaxScrollAnimatorMakable, URParallaxScrollAnimatable {

    public var configuration: URParallaxScrollConfiguration!

    public var target: UITableView

    public var upperScrollView: UIScrollView!
    public var upperImageView: UIImageView!

    public var upperLotAnimationView: LOTAnimationView!

    public var lowerScrollView: UIScrollView!
    public var lowerImageView: UIImageView!

    public var lowerLotAnimationView: LOTAnimationView!

    fileprivate init(_ base: UITableView) {
        self.target = base
        super.init()
        self.initParallaxScrollViews()
    }
}

public protocol URParallaxScrollAnimatorMakable: class {
    var configuration: URParallaxScrollConfiguration! { get set }

    var target: UITableView { get set }

    var upperScrollView: UIScrollView! { get set }
    var upperImageView: UIImageView! { get set }

    var lowerScrollView: UIScrollView! { get set }
    var lowerImageView: UIImageView! { get set }

    func makeParallaxScrollExtensionConfiguration(parallaxScrollRatio: CGFloat, parallaxScrollType: URParallaxScrollAnimationType, backgroundColor: UIColor, upperImage: UIImage, lowerImage: UIImage, upperLottieData: String!, lowerLottieData: String!)

    func initParallaxScrollViews()
}

extension URParallaxScrollAnimatorMakable {

    public func makeParallaxScrollExtensionConfiguration(parallaxScrollRatio: CGFloat = DefaultParallaxScrollRatio, parallaxScrollType: URParallaxScrollAnimationType = .upperLayer, backgroundColor: UIColor = DefaultBackgroundColor, upperImage: UIImage, lowerImage: UIImage, upperLottieData: String! = nil, lowerLottieData: String! = nil) {
        self.target.parallaxScrollExtension.configuration = URParallaxScrollConfiguration(parallaxScrollRatio: parallaxScrollRatio, parallaxScrollType: parallaxScrollType, backgroundColor: backgroundColor, upperImage: upperImage, lowerImage: lowerImage)

        self.initParallaxScrollViews()
    }

    public func initParallaxScrollViews() {
        self.configuration = self.target.parallaxScrollExtension.configuration

        guard let superview = self.target.superview else {
            fatalError("[\(URParallaxScrollExtension.self)] This tableview needs the superview!!")
        }

        superview.insertSubview(self.upperScrollView, belowSubview: self.target)
        superview.insertSubview(self.lowerScrollView, belowSubview: self.upperScrollView)

        self.upperScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.lowerScrollView.translatesAutoresizingMaskIntoConstraints = false

        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))

        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
        superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))

        self.upperImageView = UIImageView(image: self.target.parallaxScrollExtension.configuration.upperImage)
        self.upperScrollView.addSubview(self.upperImageView)

        self.lowerImageView = UIImageView(image: self.target.parallaxScrollExtension.configuration.lowerImage)
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

fileprivate enum URScrollVerticalDirection {
    case up
    case down
}

// MARK:- Util
func roundUp(_ value: Double, roundUpPosition: Int) -> Double {
    let roundUpPositionBy10 = pow(10.0, Double(roundUpPosition))
    return round(value * roundUpPositionBy10) / roundUpPositionBy10
}
