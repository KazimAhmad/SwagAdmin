//
//  FactCoordinator.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 01/02/2026.
//

import SwiftUI

class FactCoordinator: CoordinatorProtocol {
    typealias Route = FactRoute
    typealias Sheet = FactSheet
    typealias FullScreenCover = FactFullScreenCover
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?

    let repository = FactRepository(coreData: FactCoreData(context: PersistenceController.shared.container.viewContext))
    
    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .facts)
    }
    
    func build(page: FactRoute) -> some View {
        switch page {
        case .facts:
            return FunFactView(viewModel: FunFactViewModel(coordinator: self))
        }
    }
    
    func build(sheet: FactSheet) -> some View {
        switch sheet {
        case .new(let categories, let callback):
            NewFactView(viewModel: NewFactViewModel(categories: categories,
                                                    dependency: repository,
                                                    onDismiss: dismissSheet,
                                                    didPublish: callback))
        }
    }
    
    func build(fullScreenCover: FactFullScreenCover) -> some View {
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

extension FactCoordinator {
    @MainActor
    func seeAllCategories(categories: [AppCategory],
                          selectedCategory: AppCategory?,
                          didSelectCategory: ((AppCategory?) -> Void)?,
                          didClearCategory: (() -> Void)?,
                          didDeleteCategory: ((AppCategory?) -> Void)?) {
        present(fullScreenCover: .categories(.init(categories: categories,
                                                   selectedCategory: selectedCategory,
                                                   categoryType: .facts,
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
