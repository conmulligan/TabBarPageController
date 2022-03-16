# TabBarPageController

[![Version](https://img.shields.io/cocoapods/v/TabBarPageController.svg)](https://cocoapods.org/pods/TabBarPageController)
[![License](https://img.shields.io/cocoapods/l/TabBarPageController.svg)](https://cocoapods.org/pods/TabBarPageController)
[![Platform](https://img.shields.io/cocoapods/p/TabBarPageController.svg)](https://cocoapods.org/pods/TabBarPageController)

`TabBarPageController` is a container view controller that manages navigation between pages of content. Each page is represented by a child view controller embedded in a `UIPageViewController` instance, allowing users to navigate between pages by either selecting tab bar items or swiping left and right.

[![](https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/1_sm.png)](https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/1.png)
[![](https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/2_sm.png)](https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/2.png)
[![](https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/3_sm.png)](https://raw.githubusercontent.com/conmulligan/TabBarPageController/master/Example/Screenshots/3.png)

## Usage

Create a `TabBarPageController` instance and add view controllers to it:

```swift
    let tabBarController = TabBarPageController()
    tabBarController.addViewController(viewController)
```

Show a specific view controller:

```swift
    tabBarController.showViewController(viewController)
```

You can configure the appearance of tab bar items by changing the child view controllers' `UITabBarItem` values.

Although `TabBarPageController` is similar to `UITabBarController`, it's not a drop-in replacement and includes a number of important differences:

- `TabBarPageController` always hides the tab bar when a child navigation view controller pushes a new view controller. This is to avoid interfering with the navigation controller's back navigation gesture.
- Editing and the "more" navigation controller are not supported.

## Example

An example project is included under the /Example directory.

## Requirements

Requires iOS 13.0 or greater.

## Installation

`TabBarPageController` is available through the Swift Package Manager. To use `TabBarPageController` with SPM, add https://github.com/conmulligan/TabBarPageController.swift.git as a dependency.

`TabBarPageController` is also available through [CocoaPods](https://cocoapods.org). To install it, add the following line to your Podfile:

```ruby
pod 'TabBarPageController'
```

You can also just copy the `TabBarPageController.swift` file into your project.

## License

`TabBarPageController` is available under the MIT license. See the LICENSE file for more info.
