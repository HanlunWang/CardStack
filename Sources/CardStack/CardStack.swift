// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/**
 A SwiftUI view that arranges its children in a deck of cards.
 
 This component creates a visually appealing stack of cards with configurable
 spacing, scaling, and rotation effects. Cards can be navigated through
 programmatically or with optional gesture support.
 */
public struct CardStack<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    /// The collection of data items to display as cards
    internal let data: Data
    
    /// A view builder that creates the view for a single card
    @ViewBuilder private let content: (Data.Element) -> Content
    
    /// The index of the topmost card in the stack
    @Binding var currentIndex: Int
    
    /// Configuration options for the card stack
    private let configuration: CardStackConfiguration
    
    /// Information about random angles from the environment
    @Environment(\.randomAnglesInfo) private var randomAnglesInfo
    
    /// Creates a stack with the given content
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - currentIndex: The index of the topmost card in the stack
    ///   - configuration: Configuration options for the card stack
    ///   - content: A view builder that creates the view for a single card
    public init(_ data: Data, 
                currentIndex: Binding<Int> = .constant(0), 
                configuration: CardStackConfiguration = CardStackConfiguration(),
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        _currentIndex = currentIndex
        self.configuration = configuration
    }
    
    public var body: some View {
        ZStack {
            ForEach(Array(data.enumerated()), id: \.element.id) { (index, element) in
                content(element)
                    .zIndex(zIndex(for: index))
                    .offset(x: xOffset(for: index), y: 0)
                    .scaleEffect(scale(for: index), anchor: .center)
                    .rotationEffect(.degrees(rotationDegrees(for: index)))
            }
        }
    }
    
    /// Calculates the z-index for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The z-index value to ensure proper stacking order
    private func zIndex(for index: Int) -> Double {
        if index < currentIndex {
            return -Double(data.count - index)
        } else {
            return Double(data.count - index)
        }
    }
    
    /// Calculates the horizontal offset for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The horizontal offset value in points
    private func xOffset(for index: Int) -> CGFloat {
        return ((CGFloat(index) - CGFloat(currentIndex)) * configuration.cardPadding)
    }
    
    /// Calculates the scale factor for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The scale factor to apply to the card
    private func scale(for index: Int) -> CGFloat {
        return 1.0 - (configuration.scaleFactorPerCard * abs(CGFloat(index) - CGFloat(currentIndex)))
    }
    
    /// Calculates the rotation angle for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The rotation angle in degrees
    private func rotationDegrees(for index: Int) -> Double {
        // If this is the top card, always return 0 (no rotation)
        if index == currentIndex {
            return 0
        }
        
        // Calculate the base rotation based on the card's position relative to the current index
        let baseRotation = -(Double(currentIndex) - Double(index)) * configuration.rotationDegreesPerCard
        
        // Check if random angles are enabled via modifier
        if randomAnglesInfo.enabled && index < randomAnglesInfo.angles.count {
            return baseRotation + randomAnglesInfo.angles[index]
        }
        
        return baseRotation
    }
}

// MARK: - CardStack Extensions

public extension CardStack {
    /// Makes the card stack swipeable with gesture-based navigation
    /// - Returns: A modified view that responds to swipe gestures
    func swipeable() -> some View {
        self.modifier(SwipeableModifier(data: data, currentIndex: $currentIndex))
    }
    
    /// Makes the card stack swipeable with enhanced animation effects
    /// - Returns: An enhanced card stack with improved animations
    func enhancedSwipeable() -> some View {
        EnhancedCardStack(data, currentIndex: $currentIndex, content: content)
    }
}
