# URParallaxScrollAnimator

 [![Swift](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)](https://swift.org) [![podplatform](https://cocoapod-badges.herokuapp.com/p/URParallaxScrollAnimator/badge.png)](https://cocoapod-badges.herokuapp.com/p/URParallaxScrollAnimator/badge.png) [![pod](https://cocoapod-badges.herokuapp.com/v/URParallaxScrollAnimator/badge.png)](https://cocoapods.org/pods/URParallaxScrollAnimator) ![poddoc](https://img.shields.io/cocoapods/metrics/doc-percent/URParallaxScrollAnimator.svg) ![license](https://cocoapod-badges.herokuapp.com/l/URParallaxScrollAnimator/badge.png) ![travis](https://travis-ci.org/jegumhon/URParallaxScrollAnimator.svg?branch=master) [![codecov](https://codecov.io/gh/jegumhon/URParallaxScrollAnimator/branch/master/graph/badge.svg)](https://codecov.io/gh/jegumhon/URParallaxScrollAnimator) [![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)](https://github.com/CocoaPods/CocoaPods)

## What is this?
Show an animation as far as moved scroll while scrolling at the scroll view for **Swift3**  
This code style is the **`Protocol Oriented Programming`**.  
So some protocols are configured to implement the parallax scrolling.  
This extends the scrollView to make the parallax scrolling feature on the Run time, using objc_getAssociatedObject.

To show the animation as scrolling, [Lottie](http://airbnb.design/lottie/) is able to be used instead of normale UIImageView.

In addition to, you can provide the funny factor, [Haptic feedback](https://developer.apple.com/ios/human-interface-guidelines/interaction/feedback/).  
The haptic feedback is provided by scrolling down.(But only for iOS 10)

![sample](https://github.com/jegumhon/URParallaxScrollAnimator/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)

## Requirements

* iOS 8.1+
* Swift 3.0+

## Installation

### Cocoapods

Add the following to your `Podfile`.

    pod "URParallaxScrollAnimator"
    
#### Dependancy

[Lottie-iOS](https://github.com/airbnb/lottie-ios)

## Examples

See the `Example` folder.  
Run `pod install` and open the .xcworkspace file.

## Usage

```swift
import URParallaxScrollAnimator
```

#### 1. Set the Parallax Scroll maker
```swift
    // for example...
    func initView() {
        self.tableView.parallaxScrollExtension.makeParallaxScrollExtensionConfiguration(upperImage: #imageLiteral(resourceName: "cloud_by_ur2"), lowerImage: #imageLiteral(resourceName: "mountain_by_ur2"), lowerLottieData: nil)
    }
```

##### 1.1. How to use Lottie
* You can find the detail Lottie usage guide at the [Lottie-iOS](https://github.com/airbnb/lottie-ios)
* add the lottie files in the project, and then just use the json file name to load the Lottie View
![sample](https://github.com/jegumhon/URParallaxScrollAnimator/blob/master/Resources/project_setting.png?raw=true)

#### 2. Set the scroll handling functions in each UIScrollViewDelegate functions
```swift
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ...
        self.tableView.parallaxScrollExtension.parallaxScrollViewDidScroll(scrollView)
        ...
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        ...
        self.tableView.parallaxScrollExtension.parallaxScrollViewWillBeginDragging(scrollView)
        ...
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        ...
        self.tableView.parallaxScrollExtension.parallaxScrollViewDidEndDragging(scrollView)
        ...
    }
```

#### 3. Call the Pull to refresh finishing function, if you need the Pull to refresh in your app
```swift
    // for example, if calling the reload function, 
    // you must call the "parallaxScrollViewDidPullToRefresh" function just after reloading
    func handleAPICallFinish() {
        ...
        self.tableView.parallaxScrollExtension.parallaxScrollViewDidPullToRefresh()
        ...
    }
```

#### 4. 😀 Configurable parameters of URParallaxScrollAnimator 😀
* **parallaxScrollRatio** : parallax ratio between the target scroll view and upper parallax view and lower parallax view.
* **backgroundColor** : parallax scrollView's background color.
* **isEnabledHapticFeedback** : enable the [Haptic feedback](https://developer.apple.com/ios/human-interface-guidelines/interaction/feedback/). Default is "true".(but this feature is only for **iOS 10**)
* **isEnabledPullToRefresh** : enable the Pull to refresh. Default is "false".
* **refreshAction** : callback to handle the Pull to refresh.(If you set this, "isEnabledPullToRefresh" is set automatically "true")

## To-Do

- [ ] support gif for scrolling animation.

## License

URParallaxScrollAnimator is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
