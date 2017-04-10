//
//  File.swift
//  URParallaxScrollAnimator
//
//  Created by DongSoo Lee on 2017. 4. 6..
//
//

import UIKit
import Lottie

public protocol URParallaxScrollAnimatorMakable: class {
    var configuration: URParallaxScrollConfiguration! { get set }

    var target: UITableView { get set }

    var blankView: UIView! { get set }

    var upperScrollView: UIScrollView! { get set }
    var upperScrollContentView: UIView! { get set }
    var upperImageView: UIImageView! { get set }

    var lowerScrollView: UIScrollView! { get set }
    var lowerImageView: UIImageView! { get set }

    var isTriggeredRefresh: Bool { get set }
    var isPullToRefreshEnabled: Bool { get set }
    var refreshAction: (() -> Void)? { get set }

    func makeParallaxScrollExtensionConfiguration(parallaxScrollRatio: CGFloat,
                                                  parallaxScrollType: URParallaxScrollAnimationType,
                                                  backgroundColor: UIColor,
                                                  upperImage: UIImage!,
                                                  lowerImage: UIImage!,
                                                  upperLottieData: String!,
                                                  lowerLottieData: String!)

    func initParallaxScrollViews()

    func initAnimatableParallaxScrollViews()
}

extension URParallaxScrollAnimatorMakable {

    fileprivate func configScrollView(position: URParallaxScrollViewPosition) {

        guard let superview = self.target.superview else {
            fatalError("[\(URParallaxScrollExtension.self)] This tableview needs the superview!!")
        }

        let upperScrollMaker: () -> Void = {
            self.upperScrollView = UIScrollView(frame: self.target.frame)
            superview.insertSubview(self.upperScrollView, belowSubview: self.target)

            self.upperScrollView.translatesAutoresizingMaskIntoConstraints = false

            superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self.upperScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        }

        let lowerScrollMaker: () -> Void = {
            self.lowerScrollView = UIScrollView(frame: self.target.frame)
            self.lowerScrollView.backgroundColor = self.target.parallaxScrollExtension.configuration.backgroundColor
            superview.insertSubview(self.lowerScrollView, belowSubview: self.upperScrollView)

            self.lowerScrollView.translatesAutoresizingMaskIntoConstraints = false

            superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
            superview.addConstraint(NSLayoutConstraint(item: self.lowerScrollView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.target, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        }

        switch position {
        case .upper:
            upperScrollMaker()
        case .lower:
            lowerScrollMaker()
        default:
            upperScrollMaker()
            lowerScrollMaker()
        }
    }

    fileprivate func configScrollContentView(position: URParallaxScrollViewPosition, contentView: UIView, size: CGSize) {
        var scrollView: UIScrollView!

        switch position {
        case .upper:
            scrollView = self.upperScrollView

            scrollView.layoutIfNeeded()
            self.upperScrollContentView = UIView(frame: CGRect(origin: CGPoint.zero, size: scrollView.bounds.size))
            self.upperScrollContentView.backgroundColor = UIColor.clear
            scrollView.addSubview(self.upperScrollContentView)

            self.upperScrollContentView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false

            self.upperScrollContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : contentView]))
            self.upperScrollContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: [], metrics: nil, views: ["view" : contentView]))
            contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.height, multiplier: size.width / size.height, constant: 0.0))

            self.makeBlankView(container: self.upperScrollContentView, contentView: contentView)
        case .lower:
            scrollView = self.lowerScrollView

            scrollView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false

            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : contentView]))
            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view" : contentView]))
            scrollView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.height, multiplier: size.width / size.height, constant: 0.0))
        default:
            break
        }
    }

    /// make the blank area
    public func makeBlankView(container: UIView, contentView: UIView) {

        if self.blankView == nil {
            self.blankView = UIView()
            self.blankView.backgroundColor = UIColor.white
            container.addSubview(self.blankView)

            self.blankView.translatesAutoresizingMaskIntoConstraints = false
            container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[blank]-0-|", options: [], metrics: nil, views: ["blank" : self.blankView]))
            container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[content]-0-[blank]-0-|", options: [], metrics: nil, views: ["content" : contentView, "blank": self.blankView]))
        } else {
            self.blankView.isHidden = false
        }
    }

    public func hideBlankView() {
        self.blankView.isHidden = true
    }

    public func makeParallaxScrollExtensionConfiguration(parallaxScrollRatio: CGFloat = URParallaxScrollConfiguration.DefaultParallaxScrollRatio,
                                                         parallaxScrollType: URParallaxScrollAnimationType = .lowerLayer,
                                                         backgroundColor: UIColor = URParallaxScrollConfiguration.DefaultBackgroundColor,
                                                         upperImage: UIImage!,
                                                         lowerImage: UIImage!,
                                                         upperLottieData: String! = nil,
                                                         lowerLottieData: String! = nil) {
        self.target.parallaxScrollExtension.configuration = URParallaxScrollConfiguration(parallaxScrollRatio: parallaxScrollRatio, parallaxScrollType: parallaxScrollType, backgroundColor: backgroundColor, upperImage: upperImage, lowerImage: lowerImage, upperLottieData: upperLottieData, lowerLottieData: lowerLottieData)

        self.initParallaxScrollViews()
    }

    public func initParallaxScrollViews() {
        self.configuration = self.target.parallaxScrollExtension.configuration

        if let image = self.target.parallaxScrollExtension.configuration.upperImage {

            self.configScrollView(position: .upper)

            self.upperImageView = UIImageView(image: image)
            self.configScrollContentView(position: .upper, contentView: self.upperImageView, size: image.size)
        }

        if let image = self.target.parallaxScrollExtension.configuration.lowerImage {

            self.configScrollView(position: .lower)

            self.lowerImageView = UIImageView(image: image)
            self.configScrollContentView(position: .lower, contentView: self.lowerImageView, size: image.size)
        }

        self.initAnimatableParallaxScrollViews()
    }
}

extension URParallaxScrollAnimatorMakable where Self: URParallaxScrollAnimatable {
    
    public func initAnimatableParallaxScrollViews() {
        if let data = self.target.parallaxScrollExtension.configuration.upperLottieData {

            self.configScrollView(position: .upper)

            self.initLotAnimationView(position: .upper, data: data)
            self.configScrollContentView(position: .upper, contentView: self.upperLotAnimationView, size: self.upperLotAnimationView.bounds.size)
        }

        if let data = self.target.parallaxScrollExtension.configuration.lowerLottieData {

            self.configScrollView(position: .lower)

            self.initLotAnimationView(position: .lower, data: data)
            self.configScrollContentView(position: .lower, contentView: self.lowerLotAnimationView, size: self.lowerLotAnimationView.bounds.size)
        }
    }
}
