import SwiftUI

/**
 A utility class to handle card stack gestures.
 
 This class encapsulates the gesture handling logic for card stacks,
 providing a reusable component for implementing swipe navigation.
 It manages the animation and state transitions when users interact
 with the card stack.
 */
public struct CardStackGestureHandler {
    /// The current index as a Double to support smooth animations
    @Binding private var currentIndex: Double
    
    /// The previous index value, used for calculating drag offsets
    @Binding private var previousIndex: Double
    
    /// Binding to the integer index of the current card
    @Binding private var finalCurrentIndex: Int
    
    /// The number of items in the data collection
    private let dataCount: Int
    
    /**
     Initializes a new gesture handler with the specified bindings.
     
     - Parameters:
       - currentIndex: Binding to the current index as a Double
       - previousIndex: Binding to the previous index as a Double
       - finalCurrentIndex: Binding to the final index as an Int
       - dataCount: The total number of items in the data collection
     */
    public init(currentIndex: Binding<Double>, previousIndex: Binding<Double>, finalCurrentIndex: Binding<Int>, dataCount: Int) {
        _currentIndex = currentIndex
        _previousIndex = previousIndex
        _finalCurrentIndex = finalCurrentIndex
        self.dataCount = dataCount
    }
    
    /// The drag gesture that handles swipe interactions
    public var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring()) {
                    // Convert horizontal translation to an index offset
                    let x = (value.translation.width / 300) - previousIndex
                    currentIndex = -x
                    finalCurrentIndex = Int(round(currentIndex))
                }
            }
            .onEnded { value in
                snapToNearestAbsoluteIndex(value.predictedEndTranslation)
                previousIndex = currentIndex
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
                    goTo(round(previousIndex) - 1)
                } else {
                    goTo(round(previousIndex) + 1)
                }
            } else {
                // Otherwise, snap back to the nearest index
                currentIndex = round(currentIndex)
            }
        }
    }
    
    /// Navigates to the specified index with boundary checks
    /// - Parameter index: The target index to navigate to
    private func goTo(_ index: Double) {
        let maxIndex = Double(dataCount - 1)
        if index < 0 {
            currentIndex = 0
        } else if index > maxIndex {
            currentIndex = maxIndex
        } else {
            currentIndex = index
        }
        finalCurrentIndex = Int(currentIndex)
    }
} 