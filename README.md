# ViceTracking iOS SDK

Track app installs and events with the ViceOffers affiliate network.

## Requirements

- iOS 11.0+
- Xcode 13+
- Swift 5.0+


## Installation

### Swift Package Manager (Recommended)
1. In Xcode, go to File > Add Packages
2. Enter URL: `https://github.com/viceoffers/ios-sdk`
3. Click "Add Package"

### Manual Installation
1. Download `ViceTracking.swift`
2. Add to your Xcode project

## Usage

### Initialize SDK
```swift
import ViceTracking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize with your API key from ViceOffers dashboard
        ViceTracking.initialize(apiKey: "your-api-key")
        return true
    }
}

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

## Changelog

### 1.1.1 (2024-01-31)
- Fixed deep link parameter handling
- Added persistent storage of install_token and click_id
- Improved deep link parameter passing to events
- Enhanced logging for debugging

### 1.1.0
- Initial public release
- Basic event tracking
- Install attribution
