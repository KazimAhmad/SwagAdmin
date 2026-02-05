//
//  Category.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import Foundation

struct Category: Codable, Hashable {
    let id: Int
    let name: String
}

extension Category {
    init(from entity: CDFactCategory) throws {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
    }
}

extension Category {
    init(from entity: CDMovieCategory) throws {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
    }
}

extension Category {
    init(from entity: CDBookCategory) throws {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
    }
}
