//
//  Test.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 23/01/2026.
//

import Foundation
import SwiftUI

struct FloatingTabBarView: View {
    @State private var selectedTab: Tab = .home
    @Namespace private var tabAnimation

    var body: some View {
        VStack {
            Spacer()
            CustomTabBar(selectedTab: $selectedTab, namespace: tabAnimation)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case favorites = "heart.fill"
    case profile = "person.fill"
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab {
                                Circle()
                                    .fill(Color.white)
                                    .matchedGeometryEffect(id: "background", in: namespace)
                                    .frame(width: 48, height: 48)
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            }
                            Image(systemName: tab.rawValue)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(selectedTab == tab ? .blue : .gray)
                                .scaleEffect(selectedTab == tab ? 1.3 : 1.0)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(white: 0.95))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct FloatingTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBarView()
    }
}
