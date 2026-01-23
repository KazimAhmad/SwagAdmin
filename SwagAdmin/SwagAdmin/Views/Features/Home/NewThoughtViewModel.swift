//
//  NewThoughtViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 22/01/2026.
//

import Foundation

@MainActor
class NewThoughtViewModel: ObservableObject {
    @Published var thought: String = ""
    @Published var more: String = ""
    @Published var viewState: ViewState = .info
    
    var coordinator: HomeCoordinator
    var didPublish: ((Thought) -> Void)?
    
    init(coordinator: HomeCoordinator,
         didPublish: ((Thought) -> Void)?) {
        self.coordinator = coordinator
        self.didPublish = didPublish
    }
    
    func dismiss() {
        coordinator.dismissModal()
    }
    
    func publishThought() {
        viewState = .loading
        Task {
            do {
                let newID = try await Thought.create(title: thought, more: more)
                finsihPublish(id: newID)
            } catch {
                print(error)
            }
        }
    }
    
    func finsihPublish(id: Int) {
        let thought = Thought(id: id,
                              thought: self.thought,
                              more: self.more.isEmpty ? "" : self.more,
                              date: Date())
        self.didPublish?(thought)
        dismiss()
    }
    
    func saveDraft() {
        viewState = .loading
        dismiss()
    }
}
