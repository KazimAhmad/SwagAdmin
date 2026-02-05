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

    let repository = BookRepository(coreData: BookCoreData(context: PersistenceController.shared.container.viewContext))
    
    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .books)
    }
    
    func build(page: BooksRoute) -> some View {
        switch page {
        case .books:
            return BooksView(viewModel: BooksViewModel(coordinator: self))
        }
    }
    
    func build(sheet: BooksSheet) -> some View {
        switch sheet {
        case .new(let categories, let callback):
            NewBookView(viewModel: NewBookViewModel(categories: categories,
                                                    dependency: repository,
                                                    onDismiss: dismissSheet,
                                                    didPublish: callback))
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
