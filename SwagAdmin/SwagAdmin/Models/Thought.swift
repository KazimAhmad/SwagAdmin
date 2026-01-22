//
//  Thought.swift
//  Swag
//
//  Created by Kazim Ahmad on 19/01/2026.
//

import Foundation

struct Thought: Codable {
    var id: Int
    var thought: String
    var more: String?
    var date: Date
}
