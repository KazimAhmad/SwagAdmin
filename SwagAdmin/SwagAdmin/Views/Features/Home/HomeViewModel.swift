//
//  HomeViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 21/01/2026.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    private weak var coordinator: HomeCoordinator?
    @Published var thoughts: [Thought] = []
    @Published var viewState: ViewState = .loading
    
    var total: Int = 0
    var page: Int = 0
    
    init(coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
    }
    
    func goToNewThought() {
        coordinator?.present(.newThought({ newThought in
            self.thoughts.append(newThought)
        }))
    }
    
    func getThoughts() {
        page += 1
        Task {
            do {
                let thought = try await ThoughtObject.fetch(for: page)
                self.thoughts.append(contentsOf: thought.items)
                self.total = thought.total
                self.viewState = .info
            }
            catch {
                self.viewState = .error(error)
            }
        }
    }
}
