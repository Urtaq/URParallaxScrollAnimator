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
