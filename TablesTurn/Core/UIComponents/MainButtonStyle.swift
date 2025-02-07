import SwiftUI

struct MainButtonStyle: ButtonStyle {
    var maxWidth: CGFloat?
    var padding: CGFloat
    var fontSize: CGFloat
    var cornerRadius: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    var borderColor: Color?
    var borderWidth: CGFloat
    
    init(
        maxWidth: CGFloat? = .infinity,
        padding: CGFloat = 12,
        fontSize: CGFloat = 25,
        cornerRadius: CGFloat = 50,
        backgroundColor: Color = Color.accentColor,
        foregroundColor: Color = .black,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 2
    ) {
        self.maxWidth = maxWidth
        self.padding = padding
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: maxWidth)
            .padding(padding)
            .font(.system(size: fontSize))
            .foregroundColor(foregroundColor)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(configuration.isPressed
                          ? backgroundColor.opacity(0.7)
                          : backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? borderWidth : 0) // Apply border only if borderColor is set
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Default".uppercased()) {}
            .buttonStyle(MainButtonStyle()) // Uses default values (no border)
        
        Button("With Border".uppercased()) {}
            .buttonStyle(MainButtonStyle(
                maxWidth: 200,
                padding: 16,
                fontSize: 20,
                cornerRadius: 30,
                backgroundColor: .blue,
                foregroundColor: .white,
                borderColor: .black, // Adds a white border
                borderWidth: 3
            ))
    }
    .padding()
}
