//
//  CoordinatorHost.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 30/01/2026.
//

import SwiftUI

public struct CoordinatorView<Coordinator: CoordinatorProtocol>: View {
    @ObservedObject private var coordinator: Coordinator

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.mainView
                .navigationDestination(for: Coordinator.Route.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover: fullScreenCover)
                }
        }
    }
}
