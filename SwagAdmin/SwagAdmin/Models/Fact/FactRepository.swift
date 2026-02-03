//
//  FactRepository.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 01/02/2026.
//

import Combine
import CoreData
import Foundation

protocol FactRepositoryProtocol {
    func fetch(for page: Int, categoryId: Int?) async throws -> ItemsObject<FunFact>
    func create(fact: FunFact) async throws -> Int
    func delete(for ids: [Int]) async throws
    func deleteCategories(for ids: [Int]) async throws

    func fetchCategories() async throws -> [Category]
    func createCategory(name: String) async throws -> Int
    
    func factsCD() -> AnyPublisher<[FunFact], Never>
    func deleteCD(id: Int) async throws
    func createCD(fact: FunFact) async throws -> Int
}

protocol FactCoreDataProtocol {
    func factsCD() -> AnyPublisher<[FunFact], Never>
    func deleteCD(id: Int) async throws
    func createCD(fact: FunFact) async throws -> Int
}

final class FactCoreData: FactCoreDataProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createCD(fact: FunFact) async throws -> Int {
        let newFact = CDFact(context: context)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmss"
        let now = formatter.string(from: Date())
        let nowAsID = Int(now) ?? 0
        newFact.id = Int16(nowAsID)
        newFact.title = fact.title
        newFact.more = fact.description
        newFact.link = fact.link
        let category = try await factCategoryCD(cat: fact.category)
        
        newFact.category = category
        save()
        return nowAsID
    }
    
    private
    func factCategoryCD(cat: Category) async throws -> CDFactCategory? {
        let request = CDFactCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", cat.id as CVarArg)
        if let result = try? context.fetch(request).first {
            return result
        } else {
            return try await createCategoryCD(cat: cat)
        }
    }
    
    private
    func createCategoryCD(cat: Category) async throws -> CDFactCategory {
        let newCat = CDFactCategory(context: context)
        newCat.id = Int16(cat.id)
        newCat.name = cat.name
        save()
        return newCat
    }
    
    func factsCD() -> AnyPublisher<[FunFact], Never> {
        let requestCD = CDFact.fetchRequest()
        
        return context.fetchPublisher(requestCD)
            .tryMap { entities in
                try entities.map({ try FunFact(from: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func deleteCD(id: Int) async throws {
        let request = CDFact.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", id as CVarArg)
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

final class FactRepository: FactRepositoryProtocol {
    private let coreData: FactCoreDataProtocol
    
    init(coreData: FactCoreDataProtocol) {
        self.coreData = coreData
    }
    func fetch(for page: Int, categoryId: Int?) async throws -> ItemsObject<FunFact> {
        let thoughtsEndpoint = FactsEndpoint.list(page, categoryId)
        return try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
    }
    
    func create(fact: FunFact) async throws -> Int {
        let factEndpoint = FactsEndpoint.add(fact)
        let newFactIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: factEndpoint)
        return newFactIdObj.id
    }
    
    func delete(for ids: [Int]) async throws {
        let factEndpoint = FactsEndpoint.delete(ids)
        return try await SwiftServices.shared.request(endpoint: factEndpoint)
    }

    func fetchCategories() async throws -> [Category] {
        let thoughtsEndpoint = FactsEndpoint.categories
        return try await SwiftServices.shared.request(endpoint: thoughtsEndpoint)
    }
    
    func createCategory(name: String) async throws -> Int {
        let factEndpoint = FactsEndpoint.addCategory(name)
        let newFactIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: factEndpoint)
        return newFactIdObj.id
    }
    
    func deleteCategories(for ids: [Int]) async throws {
        let factDeletionEndpoint = FactsEndpoint.deleteCategories(ids)
        return try await SwiftServices.shared.request(endpoint: factDeletionEndpoint)
    }
    
    func factsCD() -> AnyPublisher<[FunFact], Never> {
        coreData.factsCD()
    }
    
    func deleteCD(id: Int) async throws {
        try await coreData.deleteCD(id: id)
    }
    
    func createCD(fact: FunFact) async throws -> Int {
        return try await coreData.createCD(fact: fact)
    }
}
