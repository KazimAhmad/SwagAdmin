//
//  Video.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 07/02/2026.
//

import Foundation

class Video: Codable {
    var id: Int
    var title: String
    var description: String?
    var url: String
    var date: Date
    
    init(id: Int, title: String, description: String? = nil, url: String, date: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.url = url
        self.date = date
    }
}
