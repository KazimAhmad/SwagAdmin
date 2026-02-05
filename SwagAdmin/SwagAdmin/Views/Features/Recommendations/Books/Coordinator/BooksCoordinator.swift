//
//  RecommendationCoordinator.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 04/02/2026.
//

import SwiftUI

class BooksCoordinator: CoordinatorProtocol {
    typealias Route = BooksRoute
    typealias Sheet = BooksSheet
    typealias FullScreenCover = BooksFullScreenCover
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?

    let movieRepository = MovieRepository(coreData: MovieCoreData(context: PersistenceController.shared.container.viewContext))
    
    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .books)
    }
    
    func build(page: BooksRoute) -> some View {
        switch page {
        case .books:
            return BooksView(viewModel: BooksViewModel())
        }
    }
    
    func build(sheet: BooksSheet) -> some View {
        switch sheet {
        case .new(let categories, let callback):
            Text("new")
        }
    }
    
    func build(fullScreenCover: BooksFullScreenCover) -> some View {
        switch fullScreenCover {
        case .seeMore(let config):
            SeeMoreView(config: config)
                .background(ClearBackgroundView())
        case .categories(let config):
            CategoriesView(viewModel: CategoriesViewModel(config: config))
                .background(ClearBackgroundView())
        case .alert(let config):
            AlertView(config: config)
                .background(ClearBackgroundView())
        }
    }
}

extension BooksCoordinator {
    @MainActor
    func seeAllCategories(categories: [Category],
                          selectedCategory: Category?,
                          didSelectCategory: ((Category?) -> Void)?,
                          didClearCategory: (() -> Void)?,
                          didDeleteCategory: ((Category?) -> Void)?) {
        present(fullScreenCover: .categories(.init(categories: categories,
                                                   selectedCategory: selectedCategory,
                                                   categoryType: .books,
                                                   didSelectCategory: { [weak self] cat in
            didSelectCategory?(cat)
            self?.dismissFullScreenCover()
        },
                                                   didClearCategory: { [weak self] in
            didClearCategory?()
            self?.dismissFullScreenCover()
        }, didDeleteCategory: { cat in
            didDeleteCategory?(cat)
        },
                                                   dismiss: { [weak self] in
            self?.dismissFullScreenCover()
        })))
    }
}
