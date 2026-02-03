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
    var releaseDate: String
    var rating: Double
    var myReview: String
}
