//
//  DraftsViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 31/01/2026.
//

import Foundation

@MainActor
class DraftsViewModel: ObservableObject {
    var section: SettingsSection
    
    var coordinator: SettingsCoordinator?
    var thoughtRepo: ThoughtRepository?
    
    @Published private(set) var thoughts: [Thought] = []
    
    init(section: SettingsSection,
         coordinator: SettingsCoordinator? = nil,
         thoughtRepo: ThoughtRepository?) {
        self.section = section
        self.coordinator = coordinator
        self.thoughtRepo = thoughtRepo
    }
    
    func getDrafts() {
        switch section {
        case .thoughts:
            guard let thoughtRepo = thoughtRepo else { return }
            thoughtRepo.thoughtsCD()
                .receive(on: DispatchQueue.main)
                .assign(to: &$thoughts)
        case .movies:
            print("todo later")
        case .books:
            print("todo later")
        case .funfacts:
            print("todo later")
        }
    }
    
    func delete(_ thought: Thought) {
        guard let thoughtRepo = thoughtRepo else { return }
        Task {
            do {
                try await thoughtRepo.deleteCD(id: thought.id)
                thoughts.removeAll { $0.id == thought.id }
            } catch {
                print("Error deleting thought: \(error)")
            }
        }
    }
    
    func updateThought(_ thought: Thought) {
        coordinator?.present(sheet: SettingsSheet.newThought(thought, { [weak self] publishedThought in
            self?.delete(thought)
        }, { [weak self] savedThought in
            self?.deleteAndUpdate(deleteThought: thought,
                                  updateThought: savedThought)
        }))
    }
    
    private func deleteAndUpdate(deleteThought: Thought, updateThought: Thought) {
        delete(deleteThought)
        thoughts.append(updateThought)
    }
}
