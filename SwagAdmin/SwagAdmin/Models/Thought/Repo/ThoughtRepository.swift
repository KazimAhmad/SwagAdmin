//
//  ThoughtRepository.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 24/01/2026.
//

import Combine
import CoreData
import Foundation

protocol ThoughtRepositoryProtocol {
    func fetch(for page: Int) async throws -> ThoughtObject
    func create(thought: String, more: String) async throws -> Int
    func delete(for ids: [Int]) async throws

    func thoughtsCD(for page: Int) -> AnyPublisher<[Thought], Never>
    func deleteCD(id: Int) async throws
    func createCD(thought: String, more: String) async throws
}

protocol ThoughtCoreDataProtocol {
    func thoughtsCD(for page: Int) -> AnyPublisher<[Thought], Never>
    func deleteCD(id: Int) async throws
    func createCD(thought: String, more: String) async throws
}

final class ThoughtCoreData: ThoughtCoreDataProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createCD(thought: String, more: String) async throws {
        let newThought = CDThought(context: context)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmss"
        let now = formatter.string(from: Date())
        let nowAsID = Int(now) ?? 0
        newThought.id = Int32(nowAsID)
        newThought.thought = thought
        newThought.more = more
        newThought.date = Date()
        save()
    }
    
    func thoughtsCD(for page: Int) -> AnyPublisher<[Thought], Never> {
        let requestCD = CDThought.fetchRequest()
        requestCD.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDThought.date, ascending: true)
        ]

        return context.fetchPublisher(requestCD)
            .tryMap { entities in
                try entities.map({ try Thought(from: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func deleteCD(id: Int) async throws {
        let request = CDThought.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let result = try? context.fetch(request).first {
            context.delete(result)
            save()
        }
    }
    
    private func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}

final class ThoughtRepository: ThoughtRepositoryProtocol {
    private let coreData: ThoughtCoreDataProtocol

    init(coreData: ThoughtCoreDataProtocol) {
        self.coreData = coreData
    }
    func fetch(for page: Int) async throws -> ThoughtObject {
        let thoughtsEndpoint = ThoughtEndpoint.list(page)
        return try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
    }
    
    func create(thought: String, more: String) async throws -> Int {
        let thoughtsEndpoint = ThoughtEndpoint.add(thought, more)
        struct NewThoughtId: Codable {
            let id: Int
        }
        let newThoughIdObj: NewThoughtId = try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
        return newThoughIdObj.id
    }
    
    func delete(for ids: [Int]) async throws {
        let thoughtsEndpoint = ThoughtEndpoint.delete(ids)
        return try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
    }

    func thoughtsCD(for page: Int) -> AnyPublisher<[Thought], Never> {
        coreData.thoughtsCD(for: page)
    }
    
    func deleteCD(id: Int) async throws {
        try await coreData.deleteCD(id: id)
    }
    
    func createCD(thought: String, more: String) async throws {
        try await coreData.createCD(thought: thought, more: more)
    }
}
