//
//  NewThoughtViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 22/01/2026.
//

import Foundation

class NewThoughtViewModel: ObservableObject {
    @Published var thought: String = ""
    @Published var more: String = ""

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
        finsihPublish()
    }
    
    func finsihPublish() {
        //TODO: - add id from API
        let thought = Thought(id: Int.random(in: 1..<500), thought: self.thought, more: self.more, date: Date())
        self.didPublish?(thought)
        dismiss()
    }
    
    func saveDraft() {
        dismiss()
    }
}
