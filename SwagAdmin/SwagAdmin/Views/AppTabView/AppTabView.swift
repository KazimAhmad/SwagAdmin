//
//  TabView.swift
//  Swag
//
//  Created by Kazim Ahmad on 14/01/2026.
//

import SwiftUI

enum AppTab: String, Hashable, CaseIterable {
    case videos
    case recommendations
    case home
    case funFacts
    case settings
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .videos:
            return "Videos"
        case .recommendations:
            return "Recommendations"
        case .funFacts:
            return "Fun Facts"
        case .settings:
            return "Settings"
        }
    }
    
    var symbolImage: String {
        switch self {
        case .home:
            return Images.home
        case .videos:
            return Images.video
        case .recommendations:
            return Images.recommendations
        case .funFacts:
            return Images.funfacts
        case .settings:
            return Images.settings
        }
    }
}

struct AppTabView: View {
    @State private var selectedTab: AppTab = .home
    var homeCoordinator = HomeCoordinator()
    var funfactsCoordinator = FactCoordinator()
    var settingsCoordinator = SettingsCoordinator()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Pompiere-Regular", size: 32)!]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Pompiere-Regular", size: 24)!]
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.title,
                              systemImage: tab.symbolImage)
                    }
                    .tag(tab)
            }
        }
    }
    
    @ViewBuilder
    func tabView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            homeCoordinator.coordinatorView
                .tag(AppTab.home)
        case .videos:
            NavigationStack {
                Text(tab.title)
            }
            .tag(AppTab.videos)
        case .recommendations:
            RecommendationView(viewModel: RecommendationViewModel())
                .tag(AppTab.recommendations)
        case .funFacts:
            funfactsCoordinator.coordinatorView
                .tag(AppTab.funFacts)
        case .settings:
            settingsCoordinator.coordinatorView
                .tag(AppTab.settings)
        }
    }
}

#Preview {
    AppTabView()
}
