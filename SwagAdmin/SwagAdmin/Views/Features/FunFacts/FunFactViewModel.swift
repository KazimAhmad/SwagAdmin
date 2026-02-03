//
//  FunFactViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 28/01/2026.
//

import Foundation

@MainActor
class FunFactViewModel: ObservableObject {
    @Published var funFactObj: ItemsObject<FunFact>?
    @Published var categories: [Category] = []
    @Published var viewState: ViewState = .loading
    
    @Published var selectedCategory: Category?
    
    var coordinator: FactCoordinator?
    var page: Int = 0
    
    init(coordinator: FactCoordinator?) {
        self.coordinator = coordinator
    }
    
    func funFacts() -> [FunFact] {
        return funFactObj?.items ?? []
    }
    
    func isSelectedCategory(_ category: Category) -> Bool {
        return selectedCategory?.id == category.id
    }
    
    func hasMoreFacts() -> Bool {
        funFactObj?.items.count ?? 0 < funFactObj?.total ?? 0
    }
    
    func showMore(of fact: FunFact) {
        let config = SeeMoreConfig(type: .fact,
                                   title: fact.title,
                                   description: fact.description) { [weak self] in
            self?.coordinator?.dismissFullScreenCover()
        }
        coordinator?.present(fullScreenCover: .seeMore(config))
    }
    
    func showDeleteAlert(for fact: FunFact) {
        let config = AlertConfig(alertType: .delete,
                                 message: "You sure you want to delete this fact?",
                                 buttons: AlertButtons(confirmTitle: "Delete",
                                                       showCancel: true,
                                                       onConfirm: { [weak self] in
            self?.delete(fact: fact)
            self?.coordinator?.dismissFullScreenCover()
        }, onCancel: { [weak self] in
            self?.coordinator?.dismissFullScreenCover()
        }))
        coordinator?.present(fullScreenCover: .alert(config))
    }
    
    func seeAllCategories() {
        coordinator?.seeAllCategories(categories: categories,
                                     selectedCategory: selectedCategory,
                                     didSelectCategory: { [weak self] cat in
            if let category = self?.categories.first(where: { $0.id == cat?.id }) {
                self?.selectedCategory = category
            } else {
                let newCategory: Category = .init(id: cat?.id ?? 0, name: cat?.name ?? "")
                self?.selectedCategory = newCategory
                self?.categories.insert(newCategory, at: 0)
            }
            self?.viewState = .loading
            self?.page = 0
            self?.funFactObj = nil
            self?.getFacts()
        }, didClearCategory: { [weak self] in
            self?.selectedCategory = nil
            self?.viewState = .loading
            self?.page = 0
            self?.funFactObj = nil
            self?.getFacts()
        }, didDeleteCategory: { [weak self] cat in
            let catToDel: Category = .init(id: cat?.id ?? 0, name: cat?.name ?? "")
            self?.categories.removeAll(where: { $0.id == catToDel.id })
        })
    }
    
    func addNewFact() {
        coordinator?.present(sheet: .new(categories,
                                         { [weak self] fact in
            if self?.funFactObj == nil {
                self?.funFactObj = .init(total: 0, items: [fact])
                self?.viewState = .info
            } else {
                self?.funFactObj?.items.insert(fact, at: 0)
                self?.funFactObj?.total = (self?.funFactObj?.total ?? 0) + 1
            }
        }))
    }
    
    func getInitialData() {
        getCategories()
        getFacts()
    }
    
    func getCategories() {
        Task {
            do {
                self.categories = try await coordinator?.repository.fetchCategories() ?? []
            } catch {
                print(error)
            }
        }
    }
    
    func getFacts() {
        page = page + 1
        Task {
            do {
                let funFact = try await coordinator?.repository.fetch(for: page, categoryId: selectedCategory?.id)
                if self.funFactObj == nil {
                    self.funFactObj = funFact
                } else {
                    self.funFactObj?.items.append(contentsOf: funFact?.items ?? [])
                }
                if funFact?.items.count ?? 0 == 0 {
                    viewState = .empty
                } else {
                    viewState = .info
                }
            } catch {
                viewState = .error(error)
            }
        }
    }
    
    func delete(fact: FunFact) {
        Task {
            do {
                try await coordinator?.repository.delete(for: [fact.id])
                funFactObj?.items.removeAll { $0.id == fact.id }
                funFactObj?.total = (funFactObj?.total ?? 0) - 1
                if funFactObj?.items.isEmpty ?? true {
                    viewState = .empty
                }
            } catch {
                print(error)
            }
        }
    }
}
