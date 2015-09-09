
# TKSubmitTransition


[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![CocoaPods](https://img.shields.io/cocoapods/v/TKSubmitTransition.svg)]()


Inpired by https://dribbble.com/shots/1945593-Login-Home-Screen

I created Animated UIButton of Loading Animation and Transition Animation.

As you can see in the GIF Animation Demo below, you can find the “Sign in” button rolling and after that, next UIViewController will fade-in. 

I made them as classes and you can use it with ease.


# Demo
![Demo GIF Animation](https://github.com/entotsu/TKSubmitTransition/blob/master/demo.gif "Demo GIF Animation")

# Installation
	pod 'TKSubmitTransition', :git => 'https://github.com/indevizible/TKSubmitTransition.git', :branch => 'swift2.0'

# Usage

## This is SubClass of UIButton

``` swift
btn = TKTransitionSubmitButton(frame: CGRectMake(0, 0, 44, 44))
```

## Animation Method
``` swift
func didStartYourLoading() {
    button.startAnimate()
}

func cancelLoading() {
    button.stopAnimate()
}

func didFinishYourLoading() {
	let secondVC = SecondViewController()
	button.transitionDuration = 1.0
	self.ts_presentViewController(secondVC, fromButton: button, animated: true, completion: nil)
}

```
