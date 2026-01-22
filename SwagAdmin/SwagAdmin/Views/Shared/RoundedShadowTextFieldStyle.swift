//
//  RoundedShadowTextFieldStyle.swift
//  Swag
//
//  Created by Kazim Ahmad on 08/01/2026.
//

import Foundation
import SwiftUI

struct RoundedShadowTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(.background)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .primary.opacity(0.5), radius: 8)
            .autocorrectionDisabled()
    }
}
