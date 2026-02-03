//
//  CategoriesViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 02/02/2026.
//

import Foundation

struct AppCategory: Identifiable {
    var id: Int
    var name: String
}

enum CategoryType: String {
    case facts = "Facts"
    case movies = "Movies"
    case books = "Books"
}

struct CategoriesConfig {
    var categories: [AppCategory]
    var categoryType: CategoryType
    var selectedCategory: AppCategory?
    var didSelectCategory: ((AppCategory?) -> Void)?
    var didClearCategory: (() -> Void)?
    var didDeleteCategory: ((AppCategory?) -> Void)?
    
    var dismiss: (() -> Void)?
    
    init(categories: [AppCategory],
         selectedCategory: AppCategory? = nil,
         categoryType: CategoryType,
         didSelectCategory: ((AppCategory?) -> Void)?,
         didClearCategory: (() -> Void)?,
         didDeleteCategory: ((AppCategory?) -> Void)?,
         dismiss: (() -> Void)?) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.categoryType = categoryType
        self.didSelectCategory = didSelectCategory
        self.didClearCategory = didClearCategory
        self.didDeleteCategory = didDeleteCategory
        self.dismiss = dismiss
    }
}

@MainActor
class CategoriesViewModel: ObservableObject {
    var categories: [AppCategory]
    var categoryType: CategoryType
    @Published var selectedCategory: AppCategory?
    
    var didSelectCategory: ((AppCategory?) -> Void)?
    var didClearCategory: (() -> Void)?
    var didDeleteCategory: ((AppCategory?) -> Void)?
    var dismiss: (() -> Void)?
    
    @Published var newCategoryName: String = ""
    @Published var categoryToDelete: AppCategory? = nil

    init(config: CategoriesConfig) {
        self.categories = config.categories
        self.selectedCategory = config.selectedCategory
        self.categoryType = config.categoryType
        self.didSelectCategory = config.didSelectCategory
        self.didClearCategory = config.didClearCategory
        self.didDeleteCategory = config.didDeleteCategory
        self.dismiss = config.dismiss
    }
    
    func isSelected(_ category: AppCategory) -> Bool {
        selectedCategory?.id == category.id
    }
    
    func selectCategory(_ category: AppCategory) {
        selectedCategory = category
    }
    
    func addCategory() {
        switch categoryType {
            case .facts:
            addFactCategory()
        case .movies:
            addMovieCategory()
        case .books:
            addBookCategory()
        }
    }
    
    func deleteCategory() {
        guard let categoryToDelete = categoryToDelete else { return }
        switch categoryType {
        case .facts:
            deleteFactCategory(categoryToDelete)
        case .movies:
            deleteMovieCategory(categoryToDelete)
        case .books:
            deleteBookCategory(categoryToDelete)
        }
    }
}

extension CategoriesViewModel {
    private func addFactCategory() {
        if newCategoryName.isEmpty { return }
        let repo = FactRepository(coreData: FactCoreData(context: PersistenceController.shared.container.viewContext))
        Task {
            do {
                let id: Int = try await repo.createCategory(name: newCategoryName)
                let newCategory = AppCategory(id: id, name: newCategoryName)
                didSelectCategory?(newCategory)
            } catch {
                print(error)
            }
        }
    }

    private func deleteFactCategory(_ categoryToDelete: AppCategory) {
        let repo = FactRepository(coreData: FactCoreData(context: PersistenceController.shared.container.viewContext))
        Task {
            do {
                try await repo.deleteCategories(for: [categoryToDelete.id])
                categories.removeAll(where: { $0.id == categoryToDelete.id })
                didDeleteCategory?(categoryToDelete)
                self.categoryToDelete = nil
            } catch {
                print(error)
            }
        }
    }

}

extension CategoriesViewModel {
    private func addMovieCategory() {
    }
    
    private func deleteMovieCategory(_ categoryToDelete: AppCategory) {
        
    }

}

extension CategoriesViewModel {
    private func addBookCategory() {
    }
    
    private func deleteBookCategory(_ categoryToDelete: AppCategory) {

    }

}
