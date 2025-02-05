//
//  PrimaryButton.swift
//  TablesTurn
//
//  Created by Ayaan Ali on 04/02/2025.
//

import SwiftUI


struct PrimaryButtonStyle: ButtonStyle {
    var maxWidth: CGFloat? = .infinity
    var padding: CGFloat = 12
    var fontSize: CGFloat = 25
    var cornerRadius: CGFloat = 50
    var backgroundColor: Color = Color.accentColor
    var foregroundColor: Color = .black
    
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
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    Button("Press".uppercased()){}.buttonStyle(PrimaryButtonStyle())
}
