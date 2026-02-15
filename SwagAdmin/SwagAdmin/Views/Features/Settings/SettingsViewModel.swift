//
//  SettingsViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 29/01/2026.
//

import SwiftUI

enum SettingsSection: String, CaseIterable {
    case thoughts = "Thoughts"
    case movies = "Movies"
    case books = "Books"
    case funfacts = "Fun Facts"
}
class SettingsViewModel: ObservableObject {
    private weak var coordinator: SettingsCoordinator?
    
    var sections: [SettingsSection] = SettingsSection.allCases
    
    @Published var cards: Cards = []
    var repository: CardRepository = CardRepository()
    
    init(coordinator: SettingsCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func navigate(to viewOf: SettingsSection) {
        let draftRoute = SettingsRoute.draft(viewOf)
        coordinator?.push(draftRoute)
    }
    
    func addNewCard() {
        let newCard = Card(id: 20,
                           title: "New Card",
                           description: "new card description",
                           image: "",
                           link: "",
                           colors: [ColorPickerHex.accent.rawValue, ColorPickerHex.secondary.rawValue],
                           textColor: "")
        coordinator?.present(sheet: .newCard(newCard, { [weak self] addedCard in
            self?.cards.insert(addedCard, at: 0)
        }))
    }
    
    @MainActor
    func getCards() {
        if cards.count > 0 { return }
        Task {
            do {
                cards = try await repository.fetch()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func delete(_ card: Card) {
        Task {
            do {
                try await repository.delete(for: [card.id])
                cards.removeAll(where: { $0.id == card.id })
            } catch {
                print(error)
            }
        }
    }
}
