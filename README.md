# ViceTracking iOS SDK

Track app installs and events with the ViceOffers affiliate network.

## Requirements

- iOS 11.0+
- Xcode 13+
- Swift 5.0+

## Installation

### CocoaPods

```ruby
pod 'ViceTracking'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/viceoffers/ios-sdk", from: "1.0.0")
]
```

## Usage

### Initialize the SDK

```swift
// In AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ViceTracking.initialize(apiKey: "your-api-key")
    return true
}
```

### Track Install

```swift
ViceTracking.trackInstall { error in
    if let error = error {
        print("Install tracking failed: \(error)")
    }
}
```

### Track Events

```swift
// Track event
ViceTracking.trackEvent("purchase")

// Track event with revenue
ViceTracking.trackEvent("purchase", revenue: 9.99)
```

### Handle Deep Links

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ViceTracking.handleDeepLink(url)
    return true
}
```

## License

MIT License. See LICENSE for details.