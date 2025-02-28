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
    
    /// The current index as a Double to support smooth animations (for swipe gestures)
    @State private var animatedIndex: Double = 0.0
    
    /// The previous index value, used for calculating drag offsets
    @State private var previousIndex: Double = 0.0
    
    /// Array of random angles for each card (when enabled)
    @State private var randomAngles: [Double] = []
    
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
        
        // Initialize state properties
        _animatedIndex = State(initialValue: Double(currentIndex.wrappedValue))
        _previousIndex = State(initialValue: Double(currentIndex.wrappedValue))
        
        // Initialize random angles if enabled
        if configuration.randomAngles.enabled {
            let count = Array(data.enumerated()).count
            _randomAngles = State(initialValue: (0..<count).map { _ in
                Double.random(in: -configuration.randomAngles.maxAngle...configuration.randomAngles.maxAngle)
            })
        }
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
        .gesture(configuration.swipeMode != .none ? dragGesture : nil)
    }
    
    /// The drag gesture that handles swipe interactions
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring()) {
                    // Convert horizontal translation to an index offset
                    let x = (value.translation.width / 300) - previousIndex
                    self.animatedIndex = -x
                    self.currentIndex = Int(round(self.animatedIndex))
                }
            }
            .onEnded { value in
                self.snapToNearestAbsoluteIndex(value.predictedEndTranslation)
                self.previousIndex = self.animatedIndex
            }
    }
    
    /// Snaps to the nearest index after a gesture ends
    /// - Parameter predictedEndTranslation: The predicted end translation of the gesture
    private func snapToNearestAbsoluteIndex(_ predictedEndTranslation: CGSize) {
        withAnimation(.interpolatingSpring(stiffness: configuration.springStiffness, damping: configuration.springDamping)) {
            let translation = predictedEndTranslation.width
            // If the swipe was significant enough, move to the next/previous card
            if abs(translation) > configuration.swipeThreshold {
                if translation > 0 {
                    self.goTo(round(self.previousIndex) - 1)
                } else {
                    self.goTo(round(self.previousIndex) + 1)
                }
            } else {
                // Otherwise, snap back to the nearest index
                self.animatedIndex = round(animatedIndex)
            }
        }
    }
    
    /// Navigates to the specified index with boundary checks
    /// - Parameter index: The target index to navigate to
    private func goTo(_ index: Double) {
        let maxIndex = Double(data.count - 1)
        if index < 0 {
            self.animatedIndex = 0
        } else if index > maxIndex {
            self.animatedIndex = maxIndex
        } else {
            self.animatedIndex = index
        }
        self.currentIndex = Int(self.animatedIndex)
    }
    
    /// Calculates the z-index for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The z-index value to ensure proper stacking order
    private func zIndex(for index: Int) -> Double {
        if configuration.swipeMode == .enhanced {
            // Enhanced mode uses a different z-index calculation
            if (Double(index) + 0.5) < animatedIndex {
                return -Double(data.count - index)
            } else {
                return Double(data.count - index)
            }
        } else {
            // Standard z-index calculation
            if index < currentIndex {
                return -Double(data.count - index)
            } else {
                return Double(data.count - index)
            }
        }
    }
    
    /// Calculates the horizontal offset for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The horizontal offset value in points
    private func xOffset(for index: Int) -> CGFloat {
        if configuration.swipeMode == .enhanced {
            // Enhanced mode with "swing out" effect
            let topCardProgress = currentPosition(for: index)
            let x = ((CGFloat(index) - animatedIndex) * configuration.cardPadding)
            
            // Apply the "swing out" effect during transitions
            if topCardProgress > 0 && topCardProgress < 0.99 && index < (data.count - 1) {
                return x * swingOutMultiplier(topCardProgress)
            }
            return x
        } else {
            // Standard offset calculation
            let indexValue = configuration.swipeMode == .normal ? animatedIndex : Double(currentIndex)
            return ((CGFloat(index) - CGFloat(indexValue)) * configuration.cardPadding)
        }
    }
    
    /// Calculates the scale factor for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The scale factor to apply to the card
    private func scale(for index: Int) -> CGFloat {
        if configuration.swipeMode == .enhanced {
            // Enhanced mode scale calculation
            return 1.0 - (configuration.scaleFactorPerCard * abs(currentPosition(for: index)))
        } else {
            // Standard scale calculation
            let indexValue = configuration.swipeMode == .normal ? animatedIndex : Double(currentIndex)
            return 1.0 - (configuration.scaleFactorPerCard * abs(CGFloat(index) - CGFloat(indexValue)))
        }
    }
    
    /// Calculates the rotation angle for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The rotation angle in degrees
    private func rotationDegrees(for index: Int) -> Double {
        // If this is the top card, always return 0 (no rotation) unless random angles are enabled
        if index == currentIndex && !configuration.randomAngles.enabled {
            return 0
        }
        
        if configuration.swipeMode == .enhanced {
            // Enhanced mode rotation calculation
            let baseRotation = -currentPosition(for: index) * configuration.rotationDegreesPerCard
            
            // Apply random angle if enabled
            if configuration.randomAngles.enabled && index < randomAngles.count {
                // Don't apply random angle to the current card
                if index == currentIndex {
                    return 0
                }
                return baseRotation + randomAngles[index]
            }
            
            return baseRotation
        } else {
            // Standard rotation calculation
            let indexValue = configuration.swipeMode == .normal ? animatedIndex : Double(currentIndex)
            let baseRotation = -(indexValue - Double(index)) * configuration.rotationDegreesPerCard
            
            // Apply random angle if enabled
            if configuration.randomAngles.enabled && index < randomAngles.count {
                // Don't apply random angle to the current card
                if index == currentIndex {
                    return 0
                }
                return baseRotation + randomAngles[index]
            }
            
            return baseRotation
        }
    }
    
    /// Calculates the current position of a card relative to the animated index
    /// - Parameter index: The index of the card
    /// - Returns: The relative position value
    private func currentPosition(for index: Int) -> Double {
        animatedIndex - Double(index)
    }
    
    /// Calculates the swing out multiplier for enhanced animations
    /// - Parameter progress: The progress value (0-1) of the animation
    /// - Returns: A multiplier value for the swing out effect
    private func swingOutMultiplier(_ progress: Double) -> Double {
        return sin(Double.pi * progress) * configuration.swingOutMultiplier
    }
}

// MARK: - CardStack Extensions

public extension CardStack {
    /// Makes the card stack swipeable with gesture-based navigation
    /// - Returns: A modified view that responds to swipe gestures
    func swipeable() -> some View {
        var newConfig = configuration
        newConfig.swipeMode = .normal
        return CardStack(data, currentIndex: $currentIndex, configuration: newConfig, content: content)
    }
    
    /// Makes the card stack swipeable with enhanced animation effects
    /// - Returns: An enhanced card stack with improved animations
    func enhancedSwipeable() -> some View {
        var newConfig = configuration
        newConfig.swipeMode = .enhanced
        return CardStack(data, currentIndex: $currentIndex, configuration: newConfig, content: content)
    }
    
    /// Applies random rotation angles to cards in the stack
    /// - Parameter maxAngle: The maximum random angle in degrees
    /// - Returns: A modified card stack with random rotation angles
    func useRandomAngles(maxAngle: Double = 5.0) -> some View {
        var newConfig = configuration
        newConfig.randomAngles = RandomAnglesSettings(enabled: true, maxAngle: maxAngle)
        return CardStack(data, currentIndex: $currentIndex, configuration: newConfig, content: content)
    }
}
