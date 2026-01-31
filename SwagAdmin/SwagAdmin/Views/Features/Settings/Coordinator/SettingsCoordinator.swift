//
//  SettingsCoordinator.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 29/01/2026.
//

import SwiftUI

class SettingsCoordinator: CoordinatorProtocol {
    typealias Route = SettingsRoute
    typealias Sheet = SettingsSheet
    typealias FullScreenCover = SettingsFullScreen
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    let thoughtRepository = ThoughtRepository(coreData: ThoughtCoreData(context: PersistenceController.shared.container.viewContext))

    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .settings)
    }
    
    func build(page: Route) -> some View {
        switch page {
        case .settings:
            SettingsView(viewModel: SettingsViewModel(coordinator: self))
        case .draft(let section):
            DraftsView(viewModel: DraftsViewModel(section: section,
                                                  coordinator: self,
                                                  thoughtRepo: thoughtRepository))
        }
    }
    
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .newThought(let existingThought, let callBackPublish, let callBackDrafts):
            NewThoughtView(viewModel: NewThoughtViewModel(dependency: thoughtRepository,
                                                          onDismiss: dismissSheet,
                                                          didPublish: callBackPublish,
                                                          didSaveDraft: callBackDrafts,
                                                          existingThought: existingThought))
        }
    }
    
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .alert(let config):
            AlertView(config: config)
                .background(ClearBackgroundView())
        }
    }
}
