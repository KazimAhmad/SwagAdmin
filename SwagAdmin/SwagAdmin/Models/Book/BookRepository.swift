//
//  BookRepository.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 05/02/2026.
//

import Combine
import CoreData
import Foundation

final class BookCoreData: CoreDataProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createCD(object: Book) async throws -> Int {
        let newBook = CDBook(context: context)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = formatter.string(from: Date())
        let nowAsID = Int(now) ?? 0
        newBook.id = Int32(nowAsID)
        newBook.title = object.title
        newBook.review = object.review
        newBook.rating = object.rating
        newBook.link = object.link
        newBook.release_year = object.releaseYear

        let category = try await bookCategoryCD(cat: object.category)
        
        newBook.category = category
        save()
        return nowAsID
    }
    
    private
    func bookCategoryCD(cat: Category) async throws -> CDBookCategory? {
        let request = CDBookCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", cat.id as CVarArg)
        if let result = try? context.fetch(request).first {
            return result
        } else {
            return try await createCategoryCD(cat: cat)
        }
    }
    
    private
    func createCategoryCD(cat: Category) async throws -> CDBookCategory {
        let newCat = CDBookCategory(context: context)
        newCat.id = Int16(cat.id)
        newCat.name = cat.name
        save()
        return newCat
    }
    
    func objectsCD() -> AnyPublisher<[Book], Never> {
        let requestCD = CDBook.fetchRequest()
        
        return context.fetchPublisher(requestCD)
            .tryMap { entities in
                try entities.map({ try Book(from: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func deleteCD(id: Int) async throws {
        let request = CDBook.fetchRequest()
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

final class BookRepository: RepositoryProtocol {
    private let coreData: BookCoreData
    
    init(coreData: BookCoreData) {
        self.coreData = coreData
    }
    func fetch(for page: Int, categoryId: Int?) async throws -> ItemsObject<Book> {
        let booksEndpoint = BooksEndpoint.list(page, categoryId)
        return try await SwiftServices.shared.request(endpoint: booksEndpoint)
    }
    
    func create(object: Book) async throws -> Int {
        let booksEndpoint = BooksEndpoint.add(object)
        let newBookIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: booksEndpoint)
        return newBookIdObj.id
    }
    
    func delete(for ids: [Int]) async throws {
        let booksEndpoint = BooksEndpoint.delete(ids)
        return try await SwiftServices.shared.request(endpoint: booksEndpoint)
    }

    func fetchCategories() async throws -> [Category] {
        let booksEndpoint = BooksEndpoint.categories
        return try await SwiftServices.shared.request(endpoint: booksEndpoint)
    }
    
    func createCategory(name: String) async throws -> Int {
        let booksEndpoint = BooksEndpoint.addCategory(name)
        let newBookIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: booksEndpoint)
        return newBookIdObj.id
    }
    
    func deleteCategories(for ids: [Int]) async throws {
        let bookDeletionEndpoint = BooksEndpoint.deleteCategories(ids)
        return try await SwiftServices.shared.request(endpoint: bookDeletionEndpoint)
    }
    
    func objectsCD() -> AnyPublisher<[Book], Never> {
        coreData.objectsCD()
    }
    
    func deleteCD(id: Int) async throws {
        try await coreData.deleteCD(id: id)
    }
    
    func createCD(object: Book) async throws -> Int {
        return try await coreData.createCD(object: object)
    }
}
