//
//  Test.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 23/01/2026.
//

import SwiftUI

struct FloatingTab: Equatable {
    var id: Int
    var title: String
    var systemIcon: String
}

struct CustomFloatingBar: View {
    @Binding var selectedOption: FloatingTab
    var options: [FloatingTab] = []
    
    var selectedColor: Color = .accentColor
    var unselectedColor: Color = .darkerOrange
    var backgroundColor: Color = Color(white: 0.90)
    var axis: Axis = .vertical
    var useTitles: Bool = true
    @Namespace var tabAnimation

    var body: some View {
        switch axis {
        case .horizontal:
            HStack {
                buttonsView(width: 48, height: 48)
            }
            .padding(10)
            .background(
                Capsule()
                    .fill(backgroundColor)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        case .vertical:
            VStack(spacing: 16) {
                buttonsView(width: 66, height: 100)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 8)
            .background(
                Capsule()
                    .fill(backgroundColor)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    func buttonsView(width: CGFloat,
                     height: CGFloat) -> some View {
        ForEach(options, id: \.id) { option in
            if axis == .horizontal {
                Spacer()
            }
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    selectedOption = option
                }
            } label: {
                VStack(spacing: 4) {
                    ZStack {
                        if selectedOption == option {
                            Capsule()
                                .fill(Color.white)
                                .matchedGeometryEffect(id: "background",
                                                       in: tabAnimation)
                                .frame(width: width, height: height)
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        Image(systemName: option.systemIcon)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(selectedOption == option ? selectedColor : unselectedColor)
                            .scaleEffect(selectedOption == option ? 1.3 : 1.0)
                    }
                    if useTitles {
                        Text(option.title)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(selectedOption == option ? selectedColor : unselectedColor)
                    }
                }
            }
            if axis == .horizontal {
                Spacer()
            }
        }
    }
}
