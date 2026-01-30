//
//  HomeCoordinator.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import Foundation
import SwiftUI

class HomeCoordinator: CoordinatorProtocol {
    typealias Route = HomeRoute
    typealias Sheet = HomeModal
    typealias FullScreenCover = HomeFullScreenModal
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    let thoughtRepository = ThoughtRepository(coreData: ThoughtCoreData(context: PersistenceController.shared.container.viewContext))

    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .home)
    }
    
    func build(page: Route) -> some View {
        switch page {
        case .home:
            HomeView(viewModel: HomeViewModel(coordinator: self,
                                              thoughtRepo: thoughtRepository))
        }
    }
    
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .newThought(let callBack):
            NewThoughtView(viewModel: NewThoughtViewModel(coordinator: self,
                                                          didPublish: callBack))
        }
    }
    
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .alert(let config):
            AlertView(config: config)
                .background(ClearBackgroundView())
        case .seeMore(let config):
            SeeMoreView(config: config)
                .background(ClearBackgroundView())
        }
    }
}
