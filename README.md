# MSLoginKit

[![CI Status](https://img.shields.io/travis/mohammedshafiullah/MSLoginKit.svg?style=flat)](https://travis-ci.org/mohammedshafiullah/MSLoginKit)
[![Version](https://img.shields.io/cocoapods/v/MSLoginKit.svg?style=flat)](https://cocoapods.org/pods/MSLoginKit)
[![License](https://img.shields.io/cocoapods/l/MSLoginKit.svg?style=flat)](https://cocoapods.org/pods/MSLoginKit)
[![Platform](https://img.shields.io/cocoapods/p/MSLoginKit.svg?style=flat)](https://cocoapods.org/pods/MSLoginKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MSLoginKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MSLoginKit'
```

## Author

Mohammed Shafiullah   mdshfiphonedev@gmail.com

## License

MSLoginKit is available under the MIT license. See the LICENSE file for more info.


## For Firebase integration
### Setup Instructions
To use FirebaseLoginKit:
1. Add `pod 'FirebaseLoginKit'` to your Podfile.
2. Add your own `GoogleService-Info.plist` from Firebase Console.
3. Call `FirebaseManager.shared.configure()` in your `App` init.
