//
//  RecommendationViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 24/01/2026.
//

import Foundation

enum RecommendationTab: Int, CaseIterable {
    case movies = 0
    case books = 1
    
    var title: String {
        switch self {
        case .movies:
            return "Movies"
        case .books:
            return "Books"
        }
    }
    
    var systemIcon: String {
        switch self {
        case .movies:
            return Images.movie
        case .books:
            return Images.book
        }
    }
}

class RecommendationViewModel: ObservableObject {
    var floatingTabs: [FloatingTab] = RecommendationTab.allCases.map { recommendation in
        FloatingTab(id: recommendation.rawValue,
                    title: recommendation.title,
                    systemIcon: recommendation.systemIcon)
    }
    @Published var selectedTab: FloatingTab
    
    init() {
        self.selectedTab = floatingTabs[0]
    }
}
