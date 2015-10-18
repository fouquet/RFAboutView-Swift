# RFAboutView-Swift

[![Version](https://img.shields.io/cocoapods/v/RFAboutView-Swift.svg?style=flat)](http://cocoapods.org/pods/RFAboutView-Swift)
[![License](https://img.shields.io/cocoapods/l/RFAboutView-Swift.svg?style=flat)](http://cocoapods.org/pods/RFAboutView-Swift)
[![Platform](https://img.shields.io/cocoapods/p/RFAboutView-Swift.svg?style=flat)](http://cocoapods.org/pods/RFAboutView-Swift)

**RFAboutView** is an easy, drop-in solution to display copyright, support, privacy and other information while also automatically crediting the developers of third-party Cocoapods. RFAboutView uses AutoLayout and can be used both for iPhone and iPad apps.

**Note**: This is the Swift version of RFAboutView. There is also a version [written in Objective-C available](https://github.com/fouquet/RFAboutView). Apart from minor implementation differences, both versions have identical feature sets and behave the same way.

Its main features are:

* Displays app name and copyright information.
* Displays an optional link to a website, opening in Safari View Controller on iOS 9, Safari on iOS 8.
* Displays an optional link to an Email address.
* If the user clicks on the Email link, a `MFMailComposeViewController` opens, (optionally) pre-filled with diagnostic information useful for support: App name and version, current device, current iOS version, preferred device language.
* Displays additional buttons with further information (for example your TOS or Privacy Policy) that you can specify.
* Displays acknowledgements for all Cocoapods used in the project. The acknowledgements file automatically created by Cocoapods is used for this, requiring almost no work on your part. See "Automatic acknowledgements" below for more information.
* Clean and modern design with lots of customisation options.

## Screenshots

<img src = "https://fouquet.me/RFAboutView/screenshot1.png" alt="Screenshot 1" width="300" height="534" />
<img src = "https://fouquet.me/RFAboutView/screenshot2.png" alt="Screenshot 2" width="300" height="534" />

## Usage

To use RFAboutView, first import it:

```swift
import RFAboutView_Swift
```

Then, initialise a RFAboutViewController and add it to a UINavigationController. The RFAboutViewController must always be used in navigation stack. Here is a complete example:

```swift
// First create a UINavigationController (or use your existing one).
// The RFAboutView needs to be wrapped in a UINavigationController.

let aboutNav = UINavigationController()

// Initialise the RFAboutView:

let aboutView = RFAboutViewController(appName: nil, appVersion: nil, appBuild: nil, copyrightHolderName: "ExampleApp, Inc.", contactEmail: "mail@example.com", contactEmailTitle: "Contact us", websiteURL: NSURL(string: "http://example.com"), websiteURLTitle: "Our Website", pubYear: nil)
        
// Set some additional options:

aboutView.headerBackgroundColor = .blackColor()
aboutView.headerTextColor = .whiteColor()
aboutView.blurStyle = .Dark
aboutView.headerBackgroundImage = UIImage(named: "about_header_bg.jpg")

// Add an additional button:
aboutView.addAdditionalButton("Privacy Policy", content: "Here's the privacy policy")

// Add the aboutView to the NavigationController:
aboutNav.setViewControllers([aboutView], animated: false)

// Present the navigation controller:
self.presentViewController(aboutNav, animated: true, completion: nil)
```

## Automatic acknowledgements

Every time you run `pod update` or `pod install`, Cocoapods automatically generates a file containing copyright and license information for all Cocoapods used in the project. RFAboutView uses this file to display the acknowledgements. To use it, copy the file `Pods-<Target Name>-acknowledgements.plist` found in the `<Project Root>/Pods/Target Support Files/Pods-<Target Name>` directory to your project and call it `Acknowledgements.plist`. You can also use a different name if you would like – if you do, set the `acknowledgementsFilename` property of `RFAboutViewController` to the new name (without plist).

To automate this, you can add the following snippet to your `Podfile`:

```ruby
post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-<Target Name>/Pods-<Target Name>-acknowledgements.plist', '<Project Dir>/Acknowledgements.plist', :remove_destination => true)
end
```
Note that the directory names can differ based on the setup of your project and whether or not you are using different targets. Check with your local project directory and change the snippet accordingly. Also don't forget to add the `Acknowledgements.plist` file to your Xcode project.

## Localisation and changing the default text

If you want to localise RFAboutView for your app or if you would like to change the default texts, you can use the [RFAboutView.strings](https://github.com/fouquet/RFAboutView/blob/master/Example/RFAboutView.strings) file in the example app as a template.

## Customization options

RFAboutView contains many customization options. See the file ``RFAboutView.swift`` for a full documentation.

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

RFAboutView requires iOS 8.0 and Xcode 7 (for Swift 2.0).

## Installation

RFAboutView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
pod "RFAboutView-Swift", '~> 1.0.10'
use_frameworks!
```

## Author

René Fouquet, mail@fouquet.me

Check out my blog: [fouquet.me](http://fouquet.me)

Follow me on Twitter at @renefouquet

## License

RFAboutView is available under the MIT license. See the LICENSE file for more info.
