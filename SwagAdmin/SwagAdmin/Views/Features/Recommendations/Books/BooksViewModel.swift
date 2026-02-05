//
//  BooksViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import Foundation

@MainActor
class BooksViewModel: ObservableObject {
    var coordinator: BooksCoordinator?
    @Published var viewState: ViewState = .loading

    @Published var booksObj: ItemsObject<Book>?
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category?

    var page: Int = 0

    init(coordinator: BooksCoordinator?) {
        self.coordinator = coordinator
        self.categories = categories
    }
    
    func books() -> [Book] {
        return booksObj?.items ?? []
    }
    
    func isSelectedCategory(_ category: Category) -> Bool {
        return selectedCategory?.id == category.id
    }
    
    func hasMoreBooks() -> Bool {
        booksObj?.items.count ?? 0 < booksObj?.total ?? 0
    }
    
    func showMore(of book: Book) {
        let config = SeeMoreConfig(type: .book,
                                   title: book.title,
                                   description: book.review) { [weak self] in
            self?.coordinator?.dismissFullScreenCover()
        }
        coordinator?.present(fullScreenCover: .seeMore(config))
    }
}

extension BooksViewModel {
    func showDeleteAlert(for book: Book) {
        let config = AlertConfig(alertType: .delete,
                                 message: "You sure you want to delete this book?",
                                 buttons: AlertButtons(confirmTitle: "Delete",
                                                       showCancel: true,
                                                       onConfirm: { [weak self] in
            self?.delete(book: book)
            self?.coordinator?.dismissFullScreenCover()
        }, onCancel: { [weak self] in
            self?.coordinator?.dismissFullScreenCover()
        }))
        coordinator?.present(fullScreenCover: .alert(config))
    }
    
    func seeAllCategories() {
        coordinator?.seeAllCategories(categories: categories,
                                      selectedCategory: selectedCategory) { [weak self] cat in
            if let category = self?.categories.first(where: { $0.id == cat?.id }) {
                self?.selectedCategory = category
            } else {
                let newCategory: Category = .init(id: cat?.id ?? 0, name: cat?.name ?? "")
                self?.selectedCategory = newCategory
                self?.categories.insert(newCategory, at: 0)
            }
            self?.viewState = .loading
            self?.page = 0
            self?.booksObj = nil
            self?.getBooks()
        } didClearCategory: { [weak self] in
            self?.selectedCategory = nil
            self?.viewState = .loading
            self?.page = 0
            self?.booksObj = nil
            self?.getBooks()
        } didDeleteCategory: { [weak self] cat in
            let catToDel: Category = .init(id: cat?.id ?? 0, name: cat?.name ?? "")
            self?.categories.removeAll(where: { $0.id == catToDel.id })
        }
    }
}

extension BooksViewModel {
    func addNewBook() {
        coordinator?.present(sheet: .new(categories,
                                         { [weak self] book in
            if self?.booksObj == nil {
                self?.booksObj = .init(total: 0, items: [book])
                self?.viewState = .info
            } else {
                self?.booksObj?.items.insert(book, at: 0)
                self?.booksObj?.total = (self?.booksObj?.total ?? 0) + 1
            }
        }))
    }
    
    func getInitialData() {
        getCategories()
        getBooks()
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
    
    func getBooks() {
        page = page + 1
        Task {
            do {
                let book = try await coordinator?.repository.fetch(for: page, categoryId: selectedCategory?.id)
                if self.booksObj == nil {
                    self.booksObj = book
                } else {
                    self.booksObj?.items.append(contentsOf: book?.items ?? [])
                }
                if book?.items.count ?? 0 == 0 {
                    viewState = .empty
                } else {
                    viewState = .info
                }
            } catch {
                viewState = .error(error)
            }
        }
    }
    
    func delete(book: Book) {
        Task {
            do {
                try await coordinator?.repository.delete(for: [book.id])
                booksObj?.items.removeAll { $0.id == book.id }
                booksObj?.total = (booksObj?.total ?? 0) - 1
                if booksObj?.items.isEmpty ?? true {
                    viewState = .empty
                }
            } catch {
                print(error)
            }
        }
    }
}
