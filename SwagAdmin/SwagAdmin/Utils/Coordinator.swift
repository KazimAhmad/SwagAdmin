//
//  Coordinator.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 30/01/2026.
//

import SwiftUI

@MainActor @preconcurrency public protocol CoordinatorProtocol: ObservableObject {
    associatedtype MainView: View

    associatedtype RouteView: View
    associatedtype SheetView: View
    associatedtype FullScreenCoverView: View

    associatedtype Route: Hashable
    associatedtype Sheet: Identifiable
    associatedtype FullScreenCover: Identifiable

    var mainView: MainView { get }

    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }

    @ViewBuilder func build(page: Route) -> RouteView
    @ViewBuilder func build(sheet: Sheet) -> SheetView
    @ViewBuilder func build(fullScreenCover: FullScreenCover) -> FullScreenCoverView
}

public extension CoordinatorProtocol {
    func push(_ page: Route) {
        path.append(page)
    }

    func present(sheet: Sheet) {
        self.sheet = sheet
    }

    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func dismissSheet() {
        sheet = nil
    }

    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
}
