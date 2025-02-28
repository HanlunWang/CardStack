![Logo](https://github.com/HanlunWang/CardStack/blob/main/demo/Logo.png)

# CardStack

An elegant SwiftUI card stack component for creating beautiful, interactive card stack interfaces.

![Basic Usage Demo](https://github.com/HanlunWang/CardStack/blob/main/demo/Demo.gif)

## Features

- Display content in a visually appealing card stack layout
- Support for programmatic and gesture-based navigation
- Multiple interaction modes: no gestures, standard gestures, and enhanced gestures
- Highly customizable appearance and behavior
- Support for iOS 16+, macOS 13+, tvOS 16+, and watchOS 9+

## Installation

Add this package to your Xcode project using Swift Package Manager:

1. In Xcode, select "File" → "Add Packages..."
2. Enter the repository URL: `https://github.com/HanlunWang/CardStack`
3. Follow the prompts to add the package to your project

## Quick Start

### Basic Usage

![Basic Usage Demo](https://github.com/HanlunWang/CardStack/blob/main/demo/BasicUsage.gif)

```swift
import SwiftUI
import CardStack

// Create a card stack with your data
CardStack(items, currentIndex: $currentIndex) { item in
    // Your card content here
    Text(item.title)
        .frame(width: 300, height: 400)
        .background(item.color)
        .cornerRadius(10)
}
```

### Enable Swipe Gestures

![Swipeable Demo](https://github.com/HanlunWang/CardStack/blob/main/demo/Swipe.gif)
![Enhanced Swipeable Demo](https://github.com/HanlunWang/CardStack/blob/main/demo/EnhancedSwipe.gif)

```swift
// Add swipe gesture support with a simple modifier
CardStack(items, currentIndex: $currentIndex) { item in
    // Your card content
}
.swipeable()

// Or use enhanced animations
CardStack(items, currentIndex: $currentIndex) { item in
    // Your card content
}
.enhancedSwipeable()
```

### Add Random Card Angles

![Random Card Angles Demo](https://github.com/HanlunWang/CardStack/blob/main/demo/Combined.gif)

```swift
// Add random rotation angles to cards
CardStack(items, currentIndex: $currentIndex) { item in
    // Your card content
}
.useRandomAngles(maxAngle: 5.0)
```

## Configuration Options

The `CardStackConfiguration` struct provides extensive customization:

| Property                 | Description                                    | Default    |
| ------------------------ | ---------------------------------------------- | ---------- |
| `swipeMode`              | Gesture mode (`.none`, `.normal`, `.enhanced`) | `.none`    |
| `cardPadding`            | Horizontal spacing between cards               | `35.0`     |
| `scaleFactorPerCard`     | Scale reduction for each card                  | `0.1`      |
| `rotationDegreesPerCard` | Rotation angle for each card                   | `2.0`      |
| `swipeThreshold`         | Distance required to trigger a swipe           | `200.0`    |
| `springStiffness`        | Animation spring stiffness                     | `300.0`    |
| `springDamping`          | Animation spring damping                       | `40.0`     |
| `swingOutMultiplier`     | Exaggeration factor for animations             | `15.0`     |
| `randomAngles`           | Settings for random card rotation              | `disabled` |

### Example Configuration

```swift
// Create a custom configuration
var config = CardStackConfiguration()
config.swipeMode = .enhanced
config.cardPadding = 40
config.scaleFactorPerCard = 0.15
config.rotationDegreesPerCard = 3.0
config.randomAngles = RandomAnglesSettings(enabled: true, maxAngle: 3.0)

// Apply the configuration
CardStack(items, currentIndex: $currentIndex, configuration: config) { item in
    // Your card content
}
```

## Gesture Modes

CardStack supports three gesture modes:

1. **No Gestures (.none)**: Disables all swipe gestures, navigation only through programmatic means.
2. **Standard Gestures (.normal)**: Enables basic swipe gestures with simple animation effects.
3. **Enhanced Gestures (.enhanced)**: Enables advanced swipe gestures with more dynamic animation effects, including "fling out" effects.

## License

This package is provided under the MIT license.
