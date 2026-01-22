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
    
    func hasMoreThoughts() -> Bool {
        return total > thoughts.count
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
    
    func refresh() {
        viewState = .loading
        page = 0
        thoughts.removeAll()
        getThoughts()
    }
    
    func delete(thought: Thought) {
        Task {
            do {
                try await thought.delete()
                self.thoughts.removeAll { $0.id == thought.id }
                thoughtDeleted()
            }
            catch {
                errorDeletingThought()
            }
        }
    }
}

//MARK: -Coordinator
extension HomeViewModel {
    func goToNewThought() {
        coordinator?.present(.newThought({ newThought in
            self.thoughts.insert(newThought, at: 0)
        }))
    }
    
    func showAlertToDelete(thought: Thought) {
        coordinator?.show(.alert(AlertConfig(alertType: .delete,
                                             message: "Are you sure you want to delete this thought?",
                                             buttons: AlertButtons(showCancel: true,
                                                                   onConfirm: { [weak self] in
            self?.delete(thought: thought)
            self?.coordinator?.dismissFullScreenModal()
        }, onCancel: { [weak self] in
            self?.coordinator?.dismissFullScreenModal()
        }))))
    }
    
    func thoughtDeleted() {
        coordinator?.show(.alert(AlertConfig(alertType: .info,
                                             message: "The thought has been successfully deleted.",
                                             buttons: AlertButtons(onConfirm: { [weak self] in
            self?.coordinator?.dismissFullScreenModal()
        }))))
    }

    func errorDeletingThought() {
        coordinator?.show(.alert(AlertConfig(alertType: .error,
                                             message: "Could not delete the thought. Please try again later.",
                                             buttons: AlertButtons(onConfirm: { [weak self] in
            self?.coordinator?.dismissFullScreenModal()
        }))))
    }
}
