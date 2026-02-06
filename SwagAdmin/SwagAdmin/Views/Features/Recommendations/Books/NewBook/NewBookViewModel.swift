//
//  NewThoughtViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 22/01/2026.
//

import Foundation

@MainActor
class NewBookViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var review: String = ""
    @Published var category: Category?
    @Published var link: String?
    @Published var rating: Double?
    @Published var releaseYear: String?

    @Published var viewState: ViewState = .info
    var categories: [Category] = []
    
    var dependency: BookRepository?
    var onDismiss: (() -> Void)?
    var didPublish: ((Book) -> Void)?
    var didSaveDraft: ((Book) -> Void)? = nil

    init(categories: [Category],
         dependency: BookRepository?,
         onDismiss: (() -> Void)?,
         didPublish: ((Book) -> Void)?,
         didSaveDraft: ((Book) -> Void)? = nil,
         existingBook: Book? = nil) {
        self.categories = categories
        self.dependency = dependency
        self.onDismiss = onDismiss
        self.didPublish = didPublish
        self.didSaveDraft = didSaveDraft
        if let existingBook = existingBook {
            self.title = existingBook.title
            self.review = existingBook.review
            self.category = existingBook.category
            self.link = existingBook.link
            self.rating = existingBook.rating
            self.releaseYear = existingBook.releaseYear
        }
    }
    
    func dismiss() {
        onDismiss?()
    }
    
    func publishBook() {
        if title.isEmpty && review.isEmpty {
            return
        }
        guard let category else {
            return
        }
        viewState = .loading
        Task {
            do {
                let rounded = ((rating ?? 0.0) * 10).rounded() / 10
                let newID = try await dependency?.create(object: Book(id: 0,
                                                                       title: title,
                                                                       review: review,
                                                                       rating: rounded,
                                                                       releaseYear: releaseYear ?? "",
                                                                       link: link ?? "",
                                                                       category: category))
                finsihPublish(id: newID ?? 0)
            } catch {
                print(error)
                viewState = .info
            }
        }
    }
    
    func finsihPublish(id: Int) {
        guard let category else {
            return
        }
        let book = Book(id: id,
                          title: title,
                          review: review,
                          rating: rating ?? 0.0,
                          releaseYear: releaseYear ?? "",
                          link: link ?? "",
                          category: category)
        self.didPublish?(book)
        dismiss()
    }
    
    func finsihDrafts(id: Int) {
        guard let category else {
            return
        }
        let book = Book(id: id,
                          title: title,
                          review: review,
                          rating: rating ?? 0.0,
                          releaseYear: releaseYear ?? "",
                          link: link ?? "",
                          category: category)
        self.didSaveDraft?(book)
        dismiss()
    }
    
    func saveDraft() {
        if title.isEmpty && review.isEmpty {
            return
        }
        guard let category else {
            return
        }
        viewState = .loading
        Task {
            do {
                let rounded = ((rating ?? 0.0) * 10).rounded() / 10
                let newID = try await dependency?.createCD(object: Book(id: 0,
                                                                         title: title,
                                                                         review: review,
                                                                         rating: rounded,
                                                                         releaseYear: releaseYear ?? "",
                                                                         link: link ?? "",
                                                                         category: category))
                viewState = .info
                finsihDrafts(id: newID ?? 0)
                dismiss()
            } catch {
                print(error)
                viewState = .info
            }
        }
    }
}
