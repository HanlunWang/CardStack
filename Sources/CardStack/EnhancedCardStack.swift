import SwiftUI

/**
 A SwiftUI view that arranges its children in a deck of cards with enhanced animation effects.
 
 This component extends the basic CardStack with more sophisticated animations,
 including a "swing out" effect during transitions and improved gesture handling.
 It provides a more dynamic and engaging user experience.
 */
public struct EnhancedCardStack<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    /// The current index as a Double to support smooth animations
    @State private var currentIndex: Double = 0.0
    
    /// The previous index value, used for calculating drag offsets
    @State private var previousIndex: Double = 0.0
    
    /// The collection of data items to display as cards
    private let data: Data
    
    /// A view builder that creates the view for a single card
    @ViewBuilder private let content: (Data.Element) -> Content
    
    /// Binding to the integer index of the current card
    @Binding var finalCurrentIndex: Int
    
    /// Creates a stack with the given content
    /// - Parameters:
    ///   - data: The identifiable data for computing the list.
    ///   - currentIndex: The index of the topmost card in the stack
    ///   - content: A view builder that creates the view for a single card
    public init(_ data: Data, currentIndex: Binding<Int> = .constant(0), @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        _finalCurrentIndex = currentIndex
        _currentIndex = State(initialValue: Double(currentIndex.wrappedValue))
        _previousIndex = State(initialValue: Double(currentIndex.wrappedValue))
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
        .highPriorityGesture(dragGesture)
    }
    
    /// The drag gesture that handles swipe interactions
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring()) {
                    // Convert horizontal translation to an index offset
                    let x = (value.translation.width / 300) - previousIndex
                    self.currentIndex = -x
                    self.finalCurrentIndex = Int(round(self.currentIndex))
                }
            }
            .onEnded { value in
                self.snapToNearestAbsoluteIndex(value.predictedEndTranslation)
                self.previousIndex = self.currentIndex
            }
    }
    
    /// Snaps to the nearest index after a gesture ends
    /// - Parameter predictedEndTranslation: The predicted end translation of the gesture
    private func snapToNearestAbsoluteIndex(_ predictedEndTranslation: CGSize) {
        withAnimation(.interpolatingSpring(stiffness: 300, damping: 40)) {
            let translation = predictedEndTranslation.width
            // If the swipe was significant enough, move to the next/previous card
            if abs(translation) > 200 {
                if translation > 0 {
                    self.goTo(round(self.previousIndex) - 1)
                } else {
                    self.goTo(round(self.previousIndex) + 1)
                }
            } else {
                // Otherwise, snap back to the nearest index
                self.currentIndex = round(currentIndex)
            }
        }
    }
    
    /// Navigates to the specified index with boundary checks
    /// - Parameter index: The target index to navigate to
    private func goTo(_ index: Double) {
        let maxIndex = Double(data.count - 1)
        if index < 0 {
            self.currentIndex = 0
        } else if index > maxIndex {
            self.currentIndex = maxIndex
        } else {
            self.currentIndex = index
        }
        self.finalCurrentIndex = Int(self.currentIndex)
    }
    
    /// Calculates the z-index for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The z-index value to ensure proper stacking order
    private func zIndex(for index: Int) -> Double {
        if (Double(index) + 0.5) < currentIndex {
            return -Double(data.count - index)
        } else {
            return Double(data.count - index)
        }
    }
    
    /// Calculates the horizontal offset for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The horizontal offset value in points, with enhanced "swing out" effect
    private func xOffset(for index: Int) -> CGFloat {
        let topCardProgress = currentPosition(for: index)
        let padding = 35.0
        let x = ((CGFloat(index) - currentIndex) * padding)
        
        // Apply the "swing out" effect during transitions
        if topCardProgress > 0 && topCardProgress < 0.99 && index < (data.count - 1) {
            return x * swingOutMultiplier(topCardProgress)
        }
        return x
    }
    
    /// Calculates the scale factor for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The scale factor to apply to the card
    private func scale(for index: Int) -> CGFloat {
        return 1.0 - (0.1 * abs(currentPosition(for: index)))
    }
    
    /// Calculates the rotation angle for a card at the specified index
    /// - Parameter index: The index of the card
    /// - Returns: The rotation angle in degrees
    private func rotationDegrees(for index: Int) -> Double {
        return -currentPosition(for: index) * 2
    }
    
    /// Calculates the current position of a card relative to the current index
    /// - Parameter index: The index of the card
    /// - Returns: The relative position value
    private func currentPosition(for index: Int) -> Double {
        currentIndex - Double(index)
    }
    
    /// Calculates the swing out multiplier for enhanced animations
    /// - Parameter progress: The progress value (0-1) of the animation
    /// - Returns: A multiplier value for the swing out effect
    private func swingOutMultiplier(_ progress: Double) -> Double {
        return sin(Double.pi * progress) * 15
    }
} 