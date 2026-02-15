//
//  CardRepository.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 15/02/2026.
//

import Foundation

final class CardRepository {
    
    func fetch(for page: Int) async throws -> Cards {
        let cardsEndpoint = CardEndpoint.list
        return try await SwiftServices.shared.request(endpoint: cardsEndpoint)
    }
    
    func create(object: Card) async throws -> Int {
        let cardsEndpoint = CardEndpoint.add(object)
        let newCardIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: cardsEndpoint)
        return newCardIdObj.id
    }
    
    func delete(for ids: [Int]) async throws {
        let cardsEndpoint = CardEndpoint.delete(ids)
        return try await SwiftServices.shared.request(endpoint: cardsEndpoint)
    }
}
