// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ViceTracking",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "ViceTracking",
            targets: ["ViceTracking"]),
    ],
    targets: [
        .target(
            name: "ViceTracking",
            dependencies: []),
    ],
    swiftLanguageVersions: [.v5]
)

// Version 1.1.1