//
//  VideosViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 07/02/2026.
//

import Foundation

@MainActor
class VideosViewModel: ObservableObject {
    @Published var videosObj: ItemsObject<Video>?
    @Published var viewState: ViewState = .loading
    
    var page: Int = 0
    
    let coordinator: VideosCoordinator?
    
    init(coordinator: VideosCoordinator?) {
        self.coordinator = coordinator
    }
    
    func videos() -> [Video] {
        videosObj?.items ?? []
    }
    
    func getVideos() {
        page = page + 1
        Task {
            do {
                let newObj = try await coordinator?.repository.fetch(for: page)
                if videosObj != nil {
                    self.videosObj?.total = newObj?.total ?? 0
                    self.videosObj?.items.append(contentsOf: newObj?.items ?? [])
                } else {
                    self.videosObj = newObj
                }
                self.viewState = videosObj?.items.count == 0 ? .empty : .info
            } catch {
                self.viewState = .error(error)
            }
        }
    }
    
    func delete(_ video: Video) {
        Task {
            do {
                try await coordinator?.repository.delete(for: [video.id])
                self.videosObj?.total = (self.videosObj?.total ?? 0) - 1
                self.videosObj?.items.removeAll(where: { $0.id == video.id })
                self.viewState = videosObj?.items.count == 0 ? .empty : .info
            } catch {
                print(error)
            }
        }
    }
}

extension VideosViewModel {
    func addNewVideo() {
        coordinator?.present(sheet: .new({ [weak self] vid in
            self?.viewState = .info
            if self?.videosObj != nil {
                self?.videosObj?.total = (self?.videosObj?.total ?? 0) + 1
                self?.videosObj?.items.insert(vid, at: 0)
            } else {
                self?.videosObj = ItemsObject(total: 1,
                                              items: [vid])
            }
        }))
    }
}
