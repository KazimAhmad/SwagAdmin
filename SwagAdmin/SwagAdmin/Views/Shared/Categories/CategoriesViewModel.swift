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
    var dismiss: (() -> Void)?
    
    init(categories: [AppCategory],
         selectedCategory: AppCategory? = nil,
         categoryType: CategoryType,
         didSelectCategory: ((AppCategory?) -> Void)?,
         didClearCategory: (() -> Void)?,
         dismiss: (() -> Void)?) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.categoryType = categoryType
        self.didSelectCategory = didSelectCategory
        self.didClearCategory = didClearCategory
        self.dismiss = dismiss
    }
}

class CategoriesViewModel: ObservableObject {
    var categories: [AppCategory]
    var categoryType: CategoryType
    @Published var selectedCategory: AppCategory?
    
    var didSelectCategory: ((AppCategory?) -> Void)?
    var didClearCategory: (() -> Void)?
    var dismiss: (() -> Void)?
    
    @Published var newCategoryName: String = ""
    
    init(config: CategoriesConfig) {
        self.categories = config.categories
        self.selectedCategory = config.selectedCategory
        self.categoryType = config.categoryType
        self.didSelectCategory = config.didSelectCategory
        self.didClearCategory = config.didClearCategory
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
    
    private func addMovieCategory() {
        
    }

    private func addBookCategory() {
        
    }
}
