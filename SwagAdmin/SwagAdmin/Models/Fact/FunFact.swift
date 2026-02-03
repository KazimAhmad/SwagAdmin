//
//  FunFact.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 25/01/2026.
//

import Foundation

struct FactObject: Decodable {
    var total: Int
    var items: [FunFact]
}

struct FunFact: Codable {
    let id: Int
    let title: String
    let description: String
    let category: FunFactCategory
    let link: String?
}

extension FunFact {
    init(from entity: CDFact) throws {
        self.id = Int(entity.id)
        self.title = entity.title ?? ""
        self.description = entity.more ?? ""
        self.link = entity.link
        if let entityCategory = entity.category {
            self.category = try .init(from: entityCategory)
        } else {
            self.category = .init(id: 0, name: "")
        }
    }
}

struct FunFactCategory: Codable, Hashable {
    let id: Int
    let name: String
}

extension FunFactCategory {
    init(from entity: CDFactCategory) throws {
        self.id = Int(entity.id)
        self.name = entity.name ?? ""
    }
}
