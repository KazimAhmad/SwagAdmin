//
//  HomeViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 21/01/2026.
//

import Foundation

class HomeViewModel: ObservableObject {
    private weak var coordinator: HomeCoordinator?
    @Published var thoughts: [Thought] = [Thought(id: 1, thought: "small string", more: "a lil more", date: Date())]
    
    init(coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
    }
    
    func goToNewThought() {
        coordinator?.present(.newThought({ newThought in
            self.thoughts.append(newThought)
        }))
    }
}
