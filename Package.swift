// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/**
 CardStack Package Configuration
 
 This package provides a customizable card stack component for SwiftUI applications.
 It supports iOS, macOS, tvOS, and watchOS platforms with a minimum version requirement.
 */
let package = Package(
    // Package name
    name: "CardStack",
    
    // Supported platforms and their minimum versions
    platforms: [
        .iOS(.v16),      // iOS 16.0 or later
        .macOS(.v13),    // macOS 13.0 or later
        .tvOS(.v16),     // tvOS 16.0 or later
        .watchOS(.v9)    // watchOS 9.0 or later
    ],
    
    // Products defined by this package
    products: [
        // The CardStack library that can be imported by other packages
        .library(
            name: "CardStack",
            targets: ["CardStack"]),
    ],
    
    // External dependencies (none for this package)
    dependencies: [
        // No external dependencies
    ],
    
    // Targets that define the modules in this package
    targets: [
        // The main CardStack target containing all the source code
        .target(
            name: "CardStack",
            dependencies: []),
    ]
)
