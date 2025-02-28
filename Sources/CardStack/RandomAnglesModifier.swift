import SwiftUI

// MARK: - CardStack Random Angles Extension

public extension CardStack {
    /// Applies random rotation angles to cards in the stack
    /// - Parameters:
    ///   - maxAngle: The maximum random angle in degrees
    ///   - count: The number of cards to generate random angles for
    /// - Returns: A modified card stack with random rotation angles
    func useRandomAngles(maxAngle: Double = 5.0) -> some View {
        // Use the count property of Array(data.enumerated()) to get the number of data items
        let count = Array(data.enumerated()).count
        return self.modifier(RandomAnglesModifier(
            count: count,
            maxRandomAngle: maxAngle
        ))
    }
}

// MARK: - Random Angles Modifier

/// A view modifier that applies random rotation angles to cards in a stack
private struct RandomAnglesModifier: ViewModifier {
    /// The number of cards in the stack
    let count: Int
    
    /// The maximum random angle to apply to each card
    let maxRandomAngle: Double
    
    /// Array of random angles for each card
    @State private var randomAngles: [Double] = []
    
    /// Initializes the modifier with the specified parameters
    /// - Parameters:
    ///   - count: The number of cards in the stack
    ///   - maxRandomAngle: The maximum random angle to apply
    init(count: Int, maxRandomAngle: Double) {
        self.count = count
        self.maxRandomAngle = maxRandomAngle
        
        // Initialize random angles for each card
        _randomAngles = State(initialValue: (0..<count).map { _ in
            Double.random(in: -maxRandomAngle...maxRandomAngle)
        })
    }
    
    /// Applies the random angles to the content
    /// - Parameter content: The content to modify
    /// - Returns: The modified content with random angles applied
    func body(content: Content) -> some View {
        content
            .environment(\.randomAnglesInfo, RandomAnglesInfo(
                enabled: true,
                angles: randomAngles,
                maxAngle: maxRandomAngle
            ))
    }
}

// MARK: - Environment Values

/// Information about random angles to be passed through the environment
struct RandomAnglesInfo {
    /// Whether random angles are enabled
    let enabled: Bool
    
    /// Array of random angles for each card
    let angles: [Double]
    
    /// The maximum random angle
    let maxAngle: Double
}

/// Environment key for random angles information
private struct RandomAnglesInfoKey: EnvironmentKey {
    static let defaultValue = RandomAnglesInfo(enabled: false, angles: [], maxAngle: 0)
}

extension EnvironmentValues {
    /// Access to random angles information through the environment
    var randomAnglesInfo: RandomAnglesInfo {
        get { self[RandomAnglesInfoKey.self] }
        set { self[RandomAnglesInfoKey.self] = newValue }
    }
} 