//
//  SettingsCoordinator.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 29/01/2026.
//

import SwiftUI

class VideosCoordinator: CoordinatorProtocol {
    typealias Route = VideosRoute
    typealias Sheet = VideosSheet
    typealias FullScreenCover = VideosFullScreen
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    let repository = VideoRepository()

    var coordinatorView: AnyView {
        AnyView(CoordinatorView(coordinator: self))
    }
    
    var mainView: some View {
        build(page: .videos)
    }
    
    func build(page: Route) -> some View {
        switch page {
        case .videos:
            VideosView(viewModel: VideosViewModel(coordinator: self))
        }
    }
    
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .new(let callback):
            NewVideoView { [weak self] addedVideo in
                self?.dismissSheet()
                callback?(addedVideo)
            }
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
