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

    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .facts)
    }
    
    func build(page: FactRoute) -> some View {
        switch page {
        case .facts:
            return FunFactView(viewModel: FunFactViewModel())
        }
    }
    
    func build(sheet: FactSheet) -> some View {
        switch sheet {
        case .new:
            Text("new")
        }
    }
    
    func build(fullScreenCover: FactFullScreenCover) -> some View {
        switch fullScreenCover {
        case .seeMore(let config):
            SeeMoreView(config: config)
        }
    }
}
