# AppEventTracker

[![CI Status](https://img.shields.io/travis/diamantidis/AppEventTracker.svg?style=flat)](https://travis-ci.org/diamantidis/AppEventTracker)
[![Version](https://img.shields.io/cocoapods/v/AppEventTracker.svg?style=flat)](https://cocoapods.org/pods/AppEventTracker)
[![License](https://img.shields.io/cocoapods/l/AppEventTracker.svg?style=flat)](https://cocoapods.org/pods/AppEventTracker)
[![Platform](https://img.shields.io/cocoapods/p/AppEventTracker.svg?style=flat)](https://cocoapods.org/pods/AppEventTracker)
[![Swift](https://img.shields.io/badge/Swift-4.0-blue.svg)](https://swift.org)
[![codecov](https://codecov.io/gh/diamantidis/AppEventTracker/branch/master/graph/badge.svg)](https://codecov.io/gh/diamantidis/AppEventTracker)


AppEventTracker is an iOS library to automatically track various events by injecting code to different functions, like for example `viewDidLoad`.
The initial reason behind this library is to track the last 10 for example events before a crash so that the user can get a better understanding of the user flow before the crash.

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 9.3+
- Xcode 10.1+
- Swift 4.2+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

AppEventTracker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AppEventTracker'
```

Then, run the following command:

```bash
$ pod install
```

## Usage 

```swift
// Import the library
import AppEventTracker
```

```swift
// Declare the number of the events to keep. 
AppEventTracker.configure(size: 10)
// Activate the events related with the viewDidLoad
AppEventTracker.enableViewDidLoad()
```

```swift
// Get the events 
print(AppEventTracker.events)
```

Can be used to send description to Hockeyapp

```swift
func applicationLog(for crashManager: BITCrashManager!) -> String! {
// prints "UIViewController1 > UIViewController2 > UIViewController3"
return AppEventTracker.events.map{ $0.name }.joined(separator: " > ")
}
```

## Author

Ioannis Diamantidis, diamantidis@outlook.com

## License

AppEventTracker is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
