//
//  RecommendationCoordinator.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 04/02/2026.
//

import SwiftUI

class MoviesCoordinator: CoordinatorProtocol {
    typealias Route = MoviesRoute
    typealias Sheet = MoviesSheet
    typealias FullScreenCover = MoviesFullScreenCover
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?

    let repository = MovieRepository(coreData: MovieCoreData(context: PersistenceController.shared.container.viewContext))
    
    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .movie)
    }
    
    func build(page: MoviesRoute) -> some View {
        switch page {
        case .movie:
            return MoviesView(viewModel: MoviesViewModel(coordinator: self))
        }
    }
    
    func build(sheet: MoviesSheet) -> some View {
        switch sheet {
        case .new(let categories, let callback):
            NewMovieView(viewModel: NewMovieViewModel(categories: categories,
                                                      dependency: repository,
                                                      onDismiss: dismissSheet,
                                                      didPublish: callback))
        }
    }
    
    func build(fullScreenCover: MoviesFullScreenCover) -> some View {
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

extension MoviesCoordinator {
    @MainActor
    func seeAllCategories(categories: [Category],
                          selectedCategory: Category?,
                          didSelectCategory: ((Category?) -> Void)?,
                          didClearCategory: (() -> Void)?,
                          didDeleteCategory: ((Category?) -> Void)?) {
        present(fullScreenCover: .categories(.init(categories: categories,
                                                   selectedCategory: selectedCategory,
                                                   categoryType: .movies,
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
