import SwiftUI

// 添加 onChange 修饰符扩展 - 移到文件顶部
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

/**
 A collection of example views demonstrating the CardStack component.
 
 This struct contains various example implementations of the CardStack
 component, showcasing different features and configurations.
 */
struct CardStackExamples {
    
    /**
     A simple data model for demonstration purposes.
     
     Each item has a name and a color, with the name serving as the identifier.
     */
    struct DemoItem: Identifiable {
        let name: String
        let color: Color
        
        var id: String {
            name
        }
    }
    
    /**
     A basic demonstration of the CardStack component.
     
     This example shows a standard card stack with manual navigation
     buttons for moving between cards.
     */
    struct CardStackDemoView: View {
        @State private var currentIndex = 0
        @State private var tappedIndex: Int? = nil
        
        var body: some View {
            // Create a collection of colored items for the demo
            let colors = [
                DemoItem(name: "#0 Red", color: .red),
                DemoItem(name: "#1 Orange", color: .orange),
                DemoItem(name: "#2 Yellow", color: .yellow),
                DemoItem(name: "#3 Green", color: .green),
                DemoItem(name: "#4 Blue", color: .blue),
                DemoItem(name: "#5 Purple", color: .purple),
            ]
            
            VStack {
                // Basic CardStack implementation
                CardStack(colors, currentIndex: $currentIndex) { namedColor in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(namedColor.color)
                        .overlay(
                            Text(namedColor.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .frame(width: 220, height: 400)
                        .onTapGesture {
                            tappedIndex = currentIndex
                        }
                        .padding(50)
                }
                
                // Display the current card index
                Text("Current card is \(currentIndex)")
                if let tappedIndex = tappedIndex {
                    Text("Card \(tappedIndex) was tapped")
                } else {
                    Text("No card has been tapped")
                }
                
                // Navigation buttons
                HStack {
                    Button("Previous") {
                        withAnimation {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }
                    }
                    .disabled(currentIndex <= 0)
                    .padding()
                    
                    Button("Next") {
                        withAnimation {
                            if currentIndex < colors.count - 1 {
                                currentIndex += 1
                            }
                        }
                    }
                    .disabled(currentIndex >= colors.count - 1)
                    .padding()
                }
            }
        }
    }
    
    /**
     A demonstration of the CardStack with swipe gestures.
     
     This example shows how to enable swipe navigation on a card stack
     using the swipeable() modifier.
     */
    struct SwipeableCardStackDemoView: View {
        @State private var currentIndex = 0
        @State private var tappedIndex: Int? = nil
        
        var body: some View {
            // Create a collection of colored items for the demo
            let colors = [
                DemoItem(name: "#0 Red", color: .red),
                DemoItem(name: "#1 Orange", color: .orange),
                DemoItem(name: "#2 Yellow", color: .yellow),
                DemoItem(name: "#3 Green", color: .green),
                DemoItem(name: "#4 Blue", color: .blue),
                DemoItem(name: "#5 Purple", color: .purple),
            ]
            
            VStack {
                // CardStack with swipeable modifier
                CardStack(colors, currentIndex: $currentIndex) { namedColor in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(namedColor.color)
                        .overlay(
                            Text(namedColor.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .frame(width: 220, height: 400)
                        .onTapGesture {
                            tappedIndex = currentIndex
                        }
                        .padding(50)
                }
                .swipeable()
                
                // Display the current card index
                Text("Current card is \(currentIndex)")
                if let tappedIndex = tappedIndex {
                    Text("Card \(tappedIndex) was tapped")
                } else {
                    Text("No card has been tapped")
                }
                
                // Instructions for the user
                Text("Swipe left or right to navigate")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    /**
     A demonstration of the CardStack with enhanced animations.
     
     This example shows how to enable enhanced swipe animations on a card stack
     using the enhancedSwipeable() modifier.
     */
    struct EnhancedCardStackDemoView: View {
        @State private var currentIndex = 0
        @State private var tappedIndex: Int? = nil
        
        var body: some View {
            // Create a collection of colored items for the demo
            let colors = [
                DemoItem(name: "#0 Red", color: .red),
                DemoItem(name: "#1 Orange", color: .orange),
                DemoItem(name: "#2 Yellow", color: .yellow),
                DemoItem(name: "#3 Green", color: .green),
                DemoItem(name: "#4 Blue", color: .blue),
                DemoItem(name: "#5 Purple", color: .purple),
            ]
            
            VStack {
                // CardStack with enhanced swipeable modifier
                CardStack(colors, currentIndex: $currentIndex) { namedColor in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(namedColor.color)
                        .overlay(
                            Text(namedColor.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .frame(width: 220, height: 400)
                        .onTapGesture {
                            tappedIndex = currentIndex
                        }
                        .padding(50)
                }
                .enhancedSwipeable()
                
                // Display the current card index
                Text("Current card is \(currentIndex)")
                if let tappedIndex = tappedIndex {
                    Text("Card \(tappedIndex) was tapped")
                } else {
                    Text("No card has been tapped")
                }
                
                // Instructions for the user
                Text("Swipe with enhanced animations")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    /**
     A demonstration of the CardStack with random angle effects.
     
     This example shows how to apply random rotation angles to cards
     using the useRandomAngles() modifier, with controls to adjust
     the maximum angle and regenerate the angles.
     */
    struct ModifierRandomAnglesCardStackDemoView: View {
        @State private var currentIndex = 0
        @State private var tappedIndex: Int? = nil
        @State private var maxRandomAngle = 8.0
        @State private var refreshToggle = false  // Used to force view refresh
        
        var body: some View {
            // Create a collection of colored items for the demo
            let colors = [
                DemoItem(name: "#0 Red", color: .red),
                DemoItem(name: "#1 Orange", color: .orange),
                DemoItem(name: "#2 Yellow", color: .yellow),
                DemoItem(name: "#3 Green", color: .green),
                DemoItem(name: "#4 Blue", color: .blue),
                DemoItem(name: "#5 Purple", color: .purple),
            ]
            
            VStack {
                // CardStack with random angles modifier
                CardStack(colors, currentIndex: $currentIndex) { namedColor in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(namedColor.color)
                        .overlay(
                            Text(namedColor.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .frame(width: 220, height: 400)
                        .onTapGesture {
                            tappedIndex = currentIndex
                        }
                        .padding(50)
                }
                .useRandomAngles(maxAngle: maxRandomAngle)
                .id(refreshToggle)  // Force view recreation when this changes
                
                // Display the current card index
                Text("Current card is \(currentIndex)")
                if let tappedIndex = tappedIndex {
                    Text("Card \(tappedIndex) was tapped")
                } else {
                    Text("No card has been tapped")
                }
                
                // Controls for adjusting the random angles
                VStack {
                    HStack {
                        Text("Max Angle: \(Int(maxRandomAngle))°")
                        Spacer()
                        Button(action: {
                            if maxRandomAngle > 1 {
                                maxRandomAngle -= 1
                                refreshToggle.toggle()
                            }
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.title2)
                        }
                        .disabled(maxRandomAngle <= 1)
                        .padding(.horizontal, 5)
                        
                        Text("\(Int(maxRandomAngle))")
                            .frame(minWidth: 30)
                            .font(.headline)
                        
                        Button(action: {
                            if maxRandomAngle < 15 {
                                maxRandomAngle += 1
                                refreshToggle.toggle()
                            }
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                        }
                        .disabled(maxRandomAngle >= 15)
                        .padding(.horizontal, 5)
                    }
                }
                
                // Button to regenerate random angles
                Button("Regenerate Random Angles") {
                    refreshToggle.toggle()  // Toggle to force view refresh
                }
                .padding()
                
                // Navigation buttons
                HStack {
                    Button("Previous") {
                        withAnimation {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }
                    }
                    .disabled(currentIndex <= 0)
                    .padding()
                    
                    Button("Next") {
                        withAnimation {
                            if currentIndex < colors.count - 1 {
                                currentIndex += 1
                            }
                        }
                    }
                    .disabled(currentIndex >= colors.count - 1)
                    .padding()
                }
            }
        }
    }
    
    /**
     A demonstration of the CardStack with combined features.
     
     This example shows how to use the new configuration-based approach
     to combine swipeable functionality with random angles.
     */
    struct CombinedFeaturesView: View {
        @State private var currentIndex = 0
        @State private var swipeMode: SwipeMode = .none
        @State private var useRandomAngles = true
        @State private var maxRandomAngle = 5.0
        @State private var refreshToggle = false  // 添加刷新触发器
        
        var body: some View {
            // Create a collection of colored items for the demo
            let colors = [
                DemoItem(name: "#0 Red", color: .red),
                DemoItem(name: "#1 Orange", color: .orange),
                DemoItem(name: "#2 Yellow", color: .yellow),
                DemoItem(name: "#3 Green", color: .green),
                DemoItem(name: "#4 Blue", color: .blue),
                DemoItem(name: "#5 Purple", color: .purple),
            ]
            
            // Create a configuration with the current settings
            var config = CardStackConfiguration()
            config.swipeMode = swipeMode
            config.randomAngles = RandomAnglesSettings(
                enabled: useRandomAngles,
                maxAngle: maxRandomAngle
            )
            
            return VStack {
                // CardStack with configuration
                CardStack(colors, currentIndex: $currentIndex, configuration: config) { namedColor in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(namedColor.color)
                        .overlay(
                            Text(namedColor.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .frame(width: 220, height: 400)
                        .shadow(radius: 5)
                }
                .id(refreshToggle)  // 添加 id 以强制视图刷新
                .padding(.bottom, 50)
                
                // Controls for swipe mode
                VStack(alignment: .leading) {
                    Text("Swipe Mode:")
                        .font(.headline)
                    
                    Picker("Swipe Mode", selection: $swipeMode) {
                        Text("None").tag(SwipeMode.none)
                        Text("Normal").tag(SwipeMode.normal)
                        Text("Enhanced").tag(SwipeMode.enhanced)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Toggle("Use Random Angles", isOn: Binding(
                        get: { useRandomAngles },
                        set: { 
                            useRandomAngles = $0
                            refreshToggle.toggle()  // 当 toggle 改变时刷新
                        }
                    ))
                    .padding(.top)
                    
                    if useRandomAngles {
                        HStack {
                            Text("Max Angle: \(Int(maxRandomAngle))°")
                            Spacer()
                            Button(action: {
                                if maxRandomAngle > 1 {
                                    maxRandomAngle -= 1
                                    refreshToggle.toggle()
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title2)
                            }
                            .disabled(maxRandomAngle <= 1)
                            .padding(.horizontal, 5)
                            
                            Text("\(Int(maxRandomAngle))")
                                .frame(minWidth: 30)
                                .font(.headline)
                            
                            Button(action: {
                                if maxRandomAngle < 15 {
                                    maxRandomAngle += 1
                                    refreshToggle.toggle()
                                }
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                            }
                            .disabled(maxRandomAngle >= 15)
                            .padding(.horizontal, 5)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.1))
                )
                .padding()
                
                Text("Current Card: \(currentIndex)")
                    .font(.headline)
                    .padding()
            }
            .padding()
        }
    }
    
    /**
     A combined view that showcases all CardStack demos in a tab view.
     
     This view provides a convenient way to navigate between the different
     CardStack examples using a tab interface.
     */
    struct CombinedDemoView: View {
        var body: some View {
            TabView {
                CardStackDemoView()
                    .tabItem {
                        Label("Standard", systemImage: "rectangle.stack")
                    }
                
                EnhancedCardStackDemoView()
                    .tabItem {
                        Label("Swipeable", systemImage: "hand.draw")
                    }
                
                CombinedFeaturesView()
                    .tabItem {
                        Label("Combined", systemImage: "square.on.circle")
                    }
            }
        }
    }
}

/// Preview provider for the combined demo view
#Preview {
    CardStackExamples.CombinedDemoView()
} 
