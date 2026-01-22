//
//  RoundedButtonStyle.swift
//  Swag
//
//  Created by Kazim Ahmad on 08/01/2026.
//

import SwiftUI

struct RoundedBorderButtonStyle: ButtonStyle {
    var backgroundColor: Color = .accentColor
    var borderColor: Color = .accentColor
    var textColor: Color = .white
    
    var cornerRadius: CGFloat = 28
    var borderWidth: CGFloat = 4

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.title(size: 16))
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                backgroundColor
                    .opacity(configuration.isPressed ? 0.85 : 1)
            )
            .foregroundColor(textColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .primary.opacity(0.6), radius: 16)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
