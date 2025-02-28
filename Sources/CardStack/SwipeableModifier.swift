import SwiftUI

/**
 A view modifier that makes a CardStack swipeable.
 
 This modifier adds drag gesture handling to a CardStack, allowing users
 to navigate between cards with swipe gestures. It includes spring animations
 and proper boundary handling.
 */
public struct SwipeableModifier: ViewModifier {
    /// The current index as a Double to support smooth animations
    @State private var currentIndex: Double = 0.0
    
    /// The previous index value, used for calculating drag offsets
    @State private var previousIndex: Double = 0.0
    
    /// Binding to the integer index of the current card
    @Binding var finalCurrentIndex: Int
    
    /// The data collection being displayed
    private let data: Any
    
    /// The number of items in the data collection
    private let dataCount: Int
    
    /// Initializes the modifier with the specified data and current index binding
    /// - Parameters:
    ///   - data: The collection of data items
    ///   - currentIndex: Binding to the current index
    public init<T>(data: T, currentIndex: Binding<Int>) where T: RandomAccessCollection {
        self.data = data
        self.dataCount = data.count
        _finalCurrentIndex = currentIndex
        _currentIndex = State(initialValue: Double(currentIndex.wrappedValue))
        _previousIndex = State(initialValue: Double(currentIndex.wrappedValue))
    }
    
    public func body(content: Content) -> some View {
        content
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
        let maxIndex = Double(dataCount - 1)
        if index < 0 {
            self.currentIndex = 0
        } else if index > maxIndex {
            self.currentIndex = maxIndex
        } else {
            self.currentIndex = index
        }
        self.finalCurrentIndex = Int(self.currentIndex)
    }
} 