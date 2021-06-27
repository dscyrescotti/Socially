# Socially 🔐
Social Sign-In integration for SwiftUI

[![Version](https://img.shields.io/cocoapods/v/Socially.svg?style=flat)](https://cocoapods.org/pods/Socially)
[![Swift](https://img.shields.io/badge/Swift-5.2-red?style=flat)](https://swift.org/blog/swift-5-2-released/)
[![License](https://img.shields.io/cocoapods/l/Socially.svg?style=flat)](https://github.com/phoelapyae69/Socially/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/Socially.svg?style=flat)](https://cocoapods.org/pods/Socially)

## Features

 - Google Sign-In Integration
 - Facebook Sign-In Integration

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. You will need [Google OAuth client ID](https://developers.google.com/identity/sign-in/ios/start-integrating) and [Facebook App ID](https://developers.facebook.com/docs/facebook-login/ios#4--configure-your-project). 
For **Google**, rename **.plist** file downloaded to **credentials.plist** and add to bundle. Then add your **reversed** client ID as a URL scheme. Check out https://developers.google.com/identity/sign-in/ios/start-integrating
For **Facebook**, add **Facebook App ID**, **Display Name**, etc to **Info.plist**. Check out https://developers.facebook.com/docs/facebook-login/ios#4--configure-your-project


## Requirements

- iOS 13.0+
 - Xcode 11.5+
 - Swift 5.2+

## Installation

Socially is available through [CocoaPods](https://cocoapods.org). To install
it, first run `pod init` in your project directory.

### • Set up for Google
To set up Google Sign-In, you will need **Google OAuth client ID**. Go to [this page](https://developers.google.com/identity/sign-in/ios/start-integrating) and create client ID. Then open Podfile and add this. 
```ruby
pod 'Socially/Google'
```
Then run `pod install` in your project directory. Make sure to open **.xcworkspace**. You need to rename **.plist** file downloaded to **credentials.plist** and add to bundle. Then add your **reversed** client ID as a URL scheme. Finally, add `Google.presentingViewController(window.rootViewController)` after this line `window.rootViewController  =  UIHostingController(rootView: contentView)` in **SceneDelegate.swift**.

### • Set up for Facebook

First of all, go to [this page](https://developers.facebook.com/docs/facebook-login/ios) and create **Facebook App ID**. Add this to Podfile.
```ruby
pod 'Socially/Facebook'
```
Then run `pod install` and open **.xcworkspace**. Then add **Facebook App ID**, **Display Name**, etc to **Info.plist**.

## Simple Usage

Add `init()` to **SwiftUI View**
```swift
init() {
	SociallyAuth.setGoogleProvider(afterSignIn: { (_, user, _) in
		if let user = user {
			print(user.profile.name ?? "N/A")
		}
	})
}
```
Then you can use **Sign-In** function with  the **specific** social sign-in inside **SwiftUI Button**. Currently, **Socially** is only available for **Google** and **Facebook**.
```swift
Button(action: {
	SociallyAuth.signIn(with: .google)
}) {
	Text("Sign In with Google")
}
```
You can easily add **Sign-Out**.
```swift
Button(action: {
	SociallyAuth.signOut()
}) {
	Text("Sign Out")
}
```
After launching the app, you can sign in silently with previous token.

```swift
.onAppear {
	SociallyAuth.restore()
}
```

## Author

**Dscyre Scotti** ([@dscyrescotti](https://twitter.com/dscyrescotti))


## License

Socially is available under the MIT license. See the LICENSE file for more info.
