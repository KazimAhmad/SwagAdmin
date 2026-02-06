//
//  NewThoughtViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 22/01/2026.
//

import Foundation

@MainActor
class NewMovieViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var myReview: String = ""
    @Published var category: Category?
    @Published var imdbLink: String?
    @Published var rating: Double?
    @Published var releaseYear: String?

    @Published var viewState: ViewState = .info
    var categories: [Category] = []
    
    var dependency: MovieRepository?
    var onDismiss: (() -> Void)?
    var didPublish: ((Movie) -> Void)?
    var didSaveDraft: ((Movie) -> Void)? = nil

    init(categories: [Category],
         dependency: MovieRepository?,
         onDismiss: (() -> Void)?,
         didPublish: ((Movie) -> Void)?,
         didSaveDraft: ((Movie) -> Void)? = nil,
         existingMovie: Movie? = nil) {
        self.categories = categories
        self.dependency = dependency
        self.onDismiss = onDismiss
        self.didPublish = didPublish
        self.didSaveDraft = didSaveDraft
        if let existingMovie = existingMovie {
            self.title = existingMovie.title
            self.myReview = existingMovie.myReview
            self.category = existingMovie.category
            self.imdbLink = existingMovie.imdbLink
            self.rating = existingMovie.rating
            self.releaseYear = existingMovie.releaseYear
        }
    }
    
    func dismiss() {
        onDismiss?()
    }
    
    func publishMovie() {
        if title.isEmpty && myReview.isEmpty {
            return
        }
        guard let category else {
            return
        }
        guard let releaseYear else {
            return
        }
        viewState = .loading
        Task {
            do {
                let rounded = ((rating ?? 0.0) * 10).rounded() / 10
                let newID = try await dependency?.create(object: Movie(id: 0,
                                                                       title: title,
                                                                       myReview: myReview,
                                                                       rating: rounded,
                                                                       releaseYear: releaseYear,
                                                                       imdbLink: imdbLink ?? "",
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
        let movie = Movie(id: id,
                          title: title,
                          myReview: myReview,
                          rating: rating ?? 0.0,
                          releaseYear: releaseYear ?? "",
                          imdbLink: imdbLink ?? "",
                          category: category)
        self.didPublish?(movie)
        dismiss()
    }
    
    func finsihDrafts(id: Int) {
        guard let category else {
            return
        }
        let movie = Movie(id: id,
                          title: title,
                          myReview: myReview,
                          rating: rating ?? 0.0,
                          releaseYear: releaseYear ?? "",
                          imdbLink: imdbLink ?? "",
                          category: category)
        self.didSaveDraft?(movie)
        dismiss()
    }
    
    func saveDraft() {
        if title.isEmpty && myReview.isEmpty {
            return
        }
        guard let category else {
            return
        }
        viewState = .loading
        Task {
            do {
                let rounded = ((rating ?? 0.0) * 10).rounded() / 10
                let newID = try await dependency?.createCD(object: Movie(id: 0,
                                                                         title: title,
                                                                         myReview: myReview,
                                                                         rating: rounded,
                                                                         releaseYear: releaseYear ?? "",
                                                                         imdbLink: imdbLink ?? "",
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
