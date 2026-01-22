//
//  Thought.swift
//  Swag
//
//  Created by Kazim Ahmad on 19/01/2026.
//

import Foundation

struct ThoughtObject: Decodable {
    let total: Int
    let items: [Thought]
    
    static func fetch(for page: Int) async throws -> Self {
        let thoughtsEndpoint = ThoughtEndpoint.list(page)
        return try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
    }
}

struct Thought: Codable {
    var id: Int
    var thought: String
    var more: String
    var date: Date
    
    static func create(title: String,
                       more: String?) async throws -> Int {
        let thoughtsEndpoint = ThoughtEndpoint.add(title, more)
        struct NewThoughtId: Codable {
            let id: Int
        }
        let newThoughIdObj: NewThoughtId = try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
        return newThoughIdObj.id
    }
    
    func delete() async throws {
        let thoughtsEndpoint = ThoughtEndpoint.delete([self.id])
        return try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
    }
}
