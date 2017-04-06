//
//  File.swift
//  URParallaxScrollAnimator
//
//  Created by DongSoo Lee on 2017. 4. 6..
//
//

import UIKit

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
