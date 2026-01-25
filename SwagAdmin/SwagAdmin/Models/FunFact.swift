//
//  FunFact.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 25/01/2026.
//

import Foundation

struct FunFact: Decodable {
    let id: Int
    let title: String
    let more: String
    let category: FunFactCategory
    let link: String?
}

struct FunFactCategory: Decodable {
    let id: Int
    let name: String
}
