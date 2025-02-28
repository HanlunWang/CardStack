import SwiftUI

/// Configuration options for CardStack
///
/// This struct provides customizable parameters to control the appearance and behavior
/// of the CardStack view, including spacing, scaling, rotation, and animation properties.
public struct CardStackConfiguration {
    /// The padding between cards in the stack
    /// 
    /// Controls the horizontal spacing between adjacent cards. Higher values create
    /// more space between cards, while lower values make the stack more compact.
    /// Default: 35.0
    public var cardPadding: CGFloat = 35.0
    
    /// The scale factor for cards
    /// 
    /// Determines how much each card is scaled down relative to the card above it.
    /// Higher values create a more pronounced scaling effect.
    /// Default: 0.1 (10% reduction per card)
    public var scaleFactorPerCard: CGFloat = 0.1
    
    /// The rotation factor for cards
    /// 
    /// Controls the rotation angle (in degrees) applied to each card.
    /// Positive values rotate clockwise, negative values rotate counterclockwise.
    /// Default: 2.0 degrees
    public var rotationDegreesPerCard: Double = 2.0
    
    /// The threshold for swipe gestures
    /// 
    /// Defines how far (in points) a card must be swiped before triggering
    /// a navigation action. Higher values require more pronounced swipes.
    /// Default: 200.0
    public var swipeThreshold: CGFloat = 200.0
    
    /// The spring stiffness for animations
    /// 
    /// Controls the stiffness of spring animations when cards are moved.
    /// Higher values create faster, more responsive animations.
    /// Default: 300.0
    public var springStiffness: Double = 300.0
    
    /// The spring damping for animations
    /// 
    /// Controls the damping of spring animations when cards are moved.
    /// Higher values reduce oscillation and create more controlled animations.
    /// Default: 40.0
    public var springDamping: Double = 40.0
    
    /// The swing out multiplier for enhanced animations
    /// 
    /// Controls the exaggeration factor for card animations during swipes.
    /// Higher values create more dramatic "swing out" effects during transitions.
    /// Default: 15.0
    public var swingOutMultiplier: Double = 15.0
    
    /// Creates a default configuration with standard values
    public init() {}
} 