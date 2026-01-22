//
//  LoadingView.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import SwiftUI

struct LoadingView: View {
    enum LoadingOffset: Float, CaseIterable {
        case left
        case center
        case right
    }
    @State var isAnimated: Bool = false
    @State var offset: LoadingOffset = .center
    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common).autoconnect()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.accentColor)
                .frame(width: isAnimated ? 200 : 60, height: 60)
                .shadow(color: .primary.opacity(0.6),
                        radius: 16)
            ProgressView()
                .tint(.white)
                .offset(x: isAnimated ? (offset == .left ? -50 : (offset == .right ? 50 : 0)) : 0)
                .onReceive(timer) { time in
                    withAnimation {
                        isAnimated.toggle()
                            if let newOffset = LoadingOffset.allCases.randomElement() {
                                offset = newOffset
                            } else {
                                offset = .center
                            }
                    }
                }
        }
    }
}

#Preview {
    LoadingView()
}
