//
//  VideoRepository.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 15/02/2026.
//

import Foundation

final class VideoRepository {
    
    func fetch(for page: Int) async throws -> ItemsObject<Video> {
        let videosEndpoint = VideoEndpoint.list(page)
        return try await SwiftServices.shared.request(endpoint: videosEndpoint)
    }
    
    func create(object: Video) async throws -> Int {
        let videosEndpoint = VideoEndpoint.add(object)
        let newVideoIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: videosEndpoint)
        return newVideoIdObj.id
    }
    
    func delete(for ids: [Int]) async throws {
        let videosEndpoint = VideoEndpoint.delete(ids)
        return try await SwiftServices.shared.request(endpoint: videosEndpoint)
    }
}
