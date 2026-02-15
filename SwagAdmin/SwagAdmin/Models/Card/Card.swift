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
        case textColor = "color_text"
        
        case colorPrimary = "color_primary"
        case colorSecondary = "color_secondary"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.link = try container.decode(String.self, forKey: .link)
        let colorPrimary = try container.decodeIfPresent(String.self, forKey: .colorPrimary) ?? ""
        let colorSecondary = try container.decodeIfPresent(String.self, forKey: .colorSecondary) ?? ""

        self.colors = [colorPrimary, colorSecondary]
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
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.image, forKey: .image)
        try container.encode(self.link, forKey: .link)
        try container.encodeIfPresent(self.textColor, forKey: .textColor)

        let primary_color = self.colors.first ?? ColorPickerHex.accent.rawValue
        let secondary_color = self.colors.last ?? ColorPickerHex.secondary.rawValue
        
        try container.encode(primary_color, forKey: .colorPrimary)
        try container.encode(secondary_color, forKey: .colorSecondary)
    }
    
    func getDicts() -> [String: Any?] {
        [
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "image": self.photoItem?.pngData(),
            "link": self.link,
            "color_primary": self.colors.first ?? "",
            "color_secondary": self.colors.last ?? "",
            "color_text": self.textColor ?? ""
        ]
    }
}

typealias Cards = [Card]
