//
//  CoreDataProtocol.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import Combine
import Foundation

protocol CoreDataProtocol {
    associatedtype Object
    func objectsCD() -> AnyPublisher<[Object], Never>
    func deleteCD(id: Int) async throws
    func createCD(object: Object) async throws -> Int
}
