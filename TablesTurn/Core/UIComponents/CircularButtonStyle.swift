import SwiftUI

struct CircularButtonStyle: ButtonStyle {
    var size: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var borderColor: Color?
    var borderWidth: CGFloat
    
    init(
        size: CGFloat = 60, // Default size
        backgroundColor: Color = Color.accentColor,
        foregroundColor: Color = .white,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 2
    ) {
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size) // Make it a circle
            .foregroundStyle(foregroundColor)
            .background(
                Circle()
                    .fill(configuration.isPressed
                          ? backgroundColor.opacity(0.7)
                          : backgroundColor)
            )
            .overlay(
                Circle()
                    .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? borderWidth : 0) // Apply border if set
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        Button(action: {}) {
            Image(systemName: "heart.fill") // Icon-only button
                .font(.system(size: 25))
        }
        .buttonStyle(CircularButtonStyle()) // Default (no border)

        Button(action: {}) {
            Image(systemName: "bell.fill")
                .font(.system(size: 30))
        }
        .buttonStyle(CircularButtonStyle(
            size: 70, // Larger button
            backgroundColor: .blue,
            foregroundColor: .white,
            borderColor: .black, // Adds a black border
            borderWidth: 3
        ))
    }
    .padding()
}
