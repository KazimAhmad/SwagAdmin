//
//  FunFact.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 25/01/2026.
//

import Foundation

struct FunFact: Codable {
    let id: Int
    let title: String
    let description: String
    let category: Category
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
