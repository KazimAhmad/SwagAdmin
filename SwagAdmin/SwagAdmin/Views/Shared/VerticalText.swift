//
//  VerticalText.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 11/02/2026.
//

import SwiftUI

struct VerticalText: View {
    let text: String
    
    var body: some View {
        GeometryReader { geo in
            Text(text)
                .font(AppTypography.title(size: 40))
                .fixedSize()
                .rotationEffect(.degrees(90), anchor: .center)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}
