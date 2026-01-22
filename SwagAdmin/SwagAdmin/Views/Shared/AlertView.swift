//
//  AlertView.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import SwiftUI

struct AlertView: View {
    @State private var isAnimated = false
    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common).autoconnect()

    var isEmptyState: Bool = false
    var tryAgain: (() -> Void)?
    init(isEmptyState: Bool = false,
         tryAgain: (() -> Void)? = nil) {
        self.isEmptyState = isEmptyState
        self.tryAgain = tryAgain
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 16) {
                Image(systemName: isEmptyState ? "archivebox.circle" : "multiply.circle")
                    .resizable()
                    .frame(width: isAnimated ? 100 : 60,
                           height: isAnimated ? 100 : 60)
                    .foregroundStyle(Color.purple)
                Text(isEmptyState ? "Empty!" : "Error!")
                    .font(AppTypography.title(size: 24))
                if isEmptyState {
                    Text("There is nothing to show yet.\nWill be back soon.")
                        .font(AppTypography.body(size: 16))
                } else {
                    Text("Had a little brain freeze while thinking.\nPlease try again later.")
                        .font(AppTypography.body(size: 16))
                }
                Button {
                    tryAgain?()
                } label: {
                    Text("Khalli Walli")
                        .font(AppTypography.body(size: 18))
                        .frame(height: 28)
                }
                .buttonStyle(RoundedBorderButtonStyle(backgroundColor: .accentColor,
                                                      borderColor: .accentColor,
                                                     cornerRadius: 28))
                .padding(.horizontal, 32)
            }
            .multilineTextAlignment(.center)
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            withAnimation {
                isAnimated.toggle()
            }
        }
    }
}

#Preview {
    AlertView()
}
