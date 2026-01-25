//
//  FunFactView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 25/01/2026.
//

import SwiftUI

struct FunFactView: View {
    let funFact: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                headerView()
            }
        }
    }
    
    func headerView() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.clear)
                .stroke(Color.accentColor, lineWidth: 2)
                .frame(height: 200)
                .padding(.horizontal, 44)
                .padding(.top, 44)
            
            Text("Did you\nknow ?".uppercased())
                .font(AppTypography.title(size: 32))
                .padding()
                .background(
                    Rectangle()
                        .fill(Color(uiColor: .systemBackground))
                )
            HStack {
                Spacer()
                Rectangle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 80, height: 80)
            }
            .padding(.bottom, 100)

            RoundedRectangle(cornerRadius: 24)
                .fill(Color.darkerOrange.opacity(0.6))
                .frame(height: 200)
                .padding(.leading, 100)
                .padding(.bottom, 44)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            Text("?")
                                .font(AppTypography.body(size: 100))
                                .rotationEffect(Angle(degrees: 30))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 44)
                }
        }
    }
}

#Preview {
    FunFactView()
}
