// swift-tools-version:5.5
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
    dependencies: [],
    targets: [
        .target(
            name: "ViceTracking",
            dependencies: []),
        .testTarget(
            name: "ViceTrackingTests",
            dependencies: ["ViceTracking"]),
    ]
)