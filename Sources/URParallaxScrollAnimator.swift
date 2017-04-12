//
//  URParallaxScrollAnimator.swift
//  URParallaxScrollAnimator
//
//  Created by DongSoo Lee on 2017. 4. 5..
//
//

import UIKit
import Lottie

public enum URParallaxScrollAnimationType {
    case upperLayer
    case lowerLayer
    case both
}

public enum URParallaxScrollViewPosition {
    case upper
    case lower
    case both
}

public enum URParallaxScrollVerticalDirection {
    case up
    case down
}

public struct URParallaxScrollConfiguration {
    public static let DefaultParallaxScrollRatio: CGFloat = 1.38
    public static let DefaultBackgroundColor: UIColor = UIColor(red: 1.0, green: 0xae / 0xff, blue: 0.0, alpha: 1.0)

    public var parallaxScrollRatio: CGFloat = URParallaxScrollConfiguration.DefaultParallaxScrollRatio

    /// unused...
    var lowerParallaxScrollRatio: CGFloat {
        return self.parallaxScrollRatio * URParallaxScrollConfiguration.DefaultParallaxScrollRatio * 1.5
    }

    var parallaxScrollType: URParallaxScrollAnimationType = .both

    var backgroundColor: UIColor = DefaultBackgroundColor

    var upperImage: UIImage!
    var lowerImage: UIImage!

    var upperLottieData: String!
    var lowerLottieData: String!

    init(parallaxScrollRatio: CGFloat = URParallaxScrollConfiguration.DefaultParallaxScrollRatio, parallaxScrollType: URParallaxScrollAnimationType = .lowerLayer, backgroundColor: UIColor = DefaultBackgroundColor, upperImage: UIImage!, lowerImage: UIImage!, upperLottieData: String! = nil, lowerLottieData: String! = nil) {
        self.parallaxScrollRatio = parallaxScrollRatio
        self.parallaxScrollType = parallaxScrollType
        self.backgroundColor = backgroundColor

        if (upperImage != nil && upperLottieData != nil) || (lowerImage != nil && lowerLottieData != nil) {
            fatalError("You need to choose whether the image is UIImage or LottieAnimation!!")
        }

        self.upperImage = upperImage
        self.lowerImage = lowerImage

        self.upperLottieData = upperLottieData
        self.lowerLottieData = lowerLottieData
    }
}

public class URParallaxScrollExtension: NSObject, URParallaxScrollAnimatorMakable, URParallaxScrollAnimatable, URParallaxScrollDelegate {

    public var configuration: URParallaxScrollConfiguration!

    public var target: UITableView
    public var targetBackgroundColor: UIColor?

    public var blankView: UIView!

    public var upperScrollView: UIScrollView!
    public var upperImageView: UIImageView!
    public var upperScrollContentView: UIView!

    public var upperLotAnimationView: LOTAnimationView!

    public var lowerScrollView: UIScrollView!
    public var lowerImageView: UIImageView!

    public var lowerLotAnimationView: LOTAnimationView!

    public var delegateParallaxScroll: URParallaxScrollDelegate!

    public var startOffsetY: CGFloat = 0.0
    public var preOffsetYUpper: CGFloat = 0.0
    public var preOffsetYLower: CGFloat = 0.0
    public var isGestureReleased: Bool = false

    public var isTriggeredRefresh: Bool = false
    public var isPullToRefreshEnabled: Bool = false
    public var refreshAction: (() -> Void)? {
        didSet {
            self.isPullToRefreshEnabled = (self.refreshAction != nil)
        }
    }

    public var hapticFeedbackGenerator: NSObject?
    public var isHapticFeedbackEnabled: Bool = true

    fileprivate init(_ base: UITableView) {
        self.target = base
        super.init()

        guard let _ = self.target.delegate else {
            fatalError("The tableview has to have the UITableViewDelegate instance!!")
        }
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

// MARK:- Util
func roundUp(_ value: Double, roundUpPosition: Int) -> Double {
    let roundUpPositionBy10 = pow(10.0, Double(roundUpPosition))
    return round(value * roundUpPositionBy10) / roundUpPositionBy10
}
