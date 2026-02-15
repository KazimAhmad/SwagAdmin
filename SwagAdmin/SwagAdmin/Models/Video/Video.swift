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
    var link: String
    var date: Date
    
    init(id: Int, title: String, description: String? = nil, link: String, date: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.link = link
        self.date = date
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.link, forKey: .link)
        let dateStr = Formatter.iso8601Format.string(from: self.date)
        try container.encode(dateStr, forKey: .date)
    }
}
