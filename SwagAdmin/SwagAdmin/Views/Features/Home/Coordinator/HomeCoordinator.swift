//
//  HomeCoordinator.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import Foundation
import SwiftUI

protocol HomeCoordinatorProtocol {
    func navigate(to destination: HomeRoute)
    func pop()
    func present(_ modal: HomeModal)
    func dismissModal()
    func show(_ modal: FullScreenModal)
    func dismissFullScreenModal()
}

class HomeCoordinator: ObservableObject, HomeCoordinatorProtocol {
    @Published var path = NavigationPath()
    @Published var activeModal: HomeModal? = nil
    @Published var activeFullScreenModal: FullScreenModal? = nil

    func navigate(to destination: HomeRoute) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    // MARK: - Modals
    func present(_ modal: HomeModal) {
        activeModal = modal
    }
    
    func dismissModal() {
        activeModal = nil
    }
    
    func show(_ modal: FullScreenModal) {
        activeFullScreenModal = modal
    }
    
    func dismissFullScreenModal() {
        activeFullScreenModal = nil
    }
}

// MARK: - View Builders
extension HomeCoordinator {
    @MainActor @ViewBuilder
    func destinationView(for destination: HomeRoute) -> some View {
        switch destination {
        default:
            Text("Not Implemented")
        }
    }
}

extension HomeCoordinator {
    @MainActor @ViewBuilder
    func modalView(for modal: HomeModal) -> some View {
        switch modal {
        case .newThought(let callBack):
            NewThoughtView(viewModel: NewThoughtViewModel(coordinator: self,
                                                          didPublish: callBack))
        }
    }
}

extension HomeCoordinator {
    @MainActor @ViewBuilder
    func fullScreenModalView(for modal: FullScreenModal) -> some View {
        switch modal {
        case .alert(let config):
            AlertView(config: config)
                .background(ClearBackgroundView())
        }
    }
}

