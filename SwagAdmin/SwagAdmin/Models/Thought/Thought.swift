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
}

struct Thought: Codable, Identifiable, Hashable {
    var id: Int
    var thought: String
    var more: String
    var date: Date
}

extension Thought {
    init(from entity: CDThought) throws {
        self.id = Int(entity.id)
        self.thought = entity.thought ?? ""
        self.more = entity.more ?? ""
        self.date = entity.date ?? Date()
    }
}
