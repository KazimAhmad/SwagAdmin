//
//  ItemsObject.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import Foundation

struct ItemsObject<T: Codable>: Codable {
    var total: Int
    var items: [T]
}
