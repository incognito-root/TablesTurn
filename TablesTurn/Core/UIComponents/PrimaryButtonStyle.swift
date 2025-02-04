//
//  PrimaryButton.swift
//  TablesTurn
//
//  Created by Ayaan Ali on 04/02/2025.
//

import SwiftUI


struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding()
            .font(.system(size: 25))
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(configuration.isPressed ? Color.accentColor.opacity(0.7) : Color.accentColor)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    Button("Press".uppercased()){}.buttonStyle(PrimaryButtonStyle())
}
