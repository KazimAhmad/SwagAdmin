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
    func present(_ modal: HomeModal)
    func pop()
    func dismissModal()
}

class HomeCoordinator: ObservableObject, HomeCoordinatorProtocol {
    @Published var path = NavigationPath()
    @Published var activeModal: HomeModal? = nil

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
    
    // MARK: - View Builders
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
