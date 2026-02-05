//
//  Book.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 05/02/2026.
//

import Foundation

struct Book: Codable {
    var id: Int
    var title: String
    var review: String
    var rating: Double
    var releaseYear: String
    var link: String
    var category: Category
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseYear = "release_year"
        case rating
        case review
        case link
        case category
    }
}

extension Book {
    init(from entity: CDBook) throws {
        self.id = Int(entity.id)
        self.title = entity.title ?? ""
        self.review = entity.review ?? ""
        self.rating = entity.rating
        self.releaseYear = entity.release_year ?? ""
        self.link = entity.link ?? ""
        if let entityCategory = entity.category {
            self.category = try .init(from: entityCategory)
        } else {
            self.category = .init(id: 0, name: "")
        }
    }
}
