//
//  Card.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 11/02/2026.
//

import UIKit

struct Card: Codable {
    var id: Int
    var title: String
    var description: String
    var image: String
    var link: String
    var colors: [String]
    var textColor: String?
    
    var photoItem: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case image
        case link
        case colors
        case textColor
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.link = try container.decode(String.self, forKey: .link)
        self.colors = try container.decode([String].self, forKey: .colors)
        self.textColor = try container.decodeIfPresent(String.self, forKey: .textColor)
        self.photoItem = nil
    }
    
    init (id: Int, title: String, description: String, image: String, link: String, colors: [String], textColor: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.link = link
        self.colors = colors
        self.textColor = textColor
        self.photoItem = nil
    }
}
