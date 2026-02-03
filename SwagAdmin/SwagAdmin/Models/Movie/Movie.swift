//
//  Movie.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var title: String
    var myReview: String
    var rating: Double
    var releaseYear: String
    var imdbLink: String
    var category: Category
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseYear = "release_year"
        case rating
        case myReview = "my_review"
        case imdbLink = "imdb_link"
        case category
    }
}

extension Movie {
    init(from entity: CDMovie) throws {
        self.id = Int(entity.id)
        self.title = entity.title ?? ""
        self.myReview = entity.my_review ?? ""
        self.rating = entity.rating
        self.releaseYear = entity.release_year ?? ""
        self.imdbLink = entity.imdb_link ?? ""
        if let entityCategory = entity.category {
            self.category = try .init(from: entityCategory)
        } else {
            self.category = .init(id: 0, name: "")
        }
    }
}
