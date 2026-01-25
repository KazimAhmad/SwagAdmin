//
//  RecommendationViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 24/01/2026.
//

import Foundation

class RecommendationViewModel: ObservableObject {
    var floatingTabs: [FloatingTab] = []
    @Published var selectedTab: FloatingTab
    
    init() {
        self.floatingTabs = [.init(id: 0,
                                   title: "Movies",
                                   systemIcon: Images.movie),
                             .init(id: 1,
                                   title: "Books",
                                   systemIcon: Images.book)]
        self.selectedTab = floatingTabs[0]
    }
}
