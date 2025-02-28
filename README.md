# CardStack

A SwiftUI package that arranges views in a beautiful, interactive card stack.

## Features

- Display content in a visually appealing card stack layout
- Easily navigate between cards
- Optional swipeable gesture support with the `.swipeable()` modifier
- Customizable appearance and behavior

## Installation

Add this package to your Xcode project using Swift Package Manager:

1. In Xcode, select "File" → "Add Packages..."
2. Enter the repository URL: `https://github.com/yourusername/CardStack`
3. Follow the prompts to add the package to your project

## Usage

### Basic Card Stack

```swift
import SwiftUI
import CardStack

struct ContentView: View {
    @State private var currentIndex = 0

    let items = [
        Item(id: "1", title: "Card 1", color: .red),
        Item(id: "2", title: "Card 2", color: .blue),
        Item(id: "3", title: "Card 3", color: .green),
    ]

    var body: some View {
        VStack {
            CardStack(items, currentIndex: $currentIndex) { item in
                RoundedRectangle(cornerRadius: 20)
                    .fill(item.color)
                    .overlay(
                        Text(item.title)
                            .foregroundColor(.white)
                    )
                    .frame(height: 400)
                    .padding()
            }

            HStack {
                Button("Previous") {
                    withAnimation {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                }

                Button("Next") {
                    withAnimation {
                        if currentIndex < items.count - 1 {
                            currentIndex += 1
                        }
                    }
                }
            }
        }
    }
}

struct Item: Identifiable {
    let id: String
    let title: String
    let color: Color
}
```

### Swipeable Card Stack

Simply add the `.swipeable()` modifier to enable gesture-based navigation:

```swift
CardStack(items, currentIndex: $currentIndex) { item in
    // Your card content here
}
.swipeable()
```

## License

This package is available under the MIT license.
