//
//  MovieRepository.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import Combine
import CoreData
import Foundation

protocol RepositoryProtocol {
    associatedtype FetchItemsObject
    associatedtype FetchObject
    associatedtype FetchCategory

    func fetch(for page: Int, categoryId: Int?) async throws -> FetchItemsObject
    func create(object: FetchObject) async throws -> Int
    func delete(for ids: [Int]) async throws
    func deleteCategories(for ids: [Int]) async throws

    func fetchCategories() async throws -> [FetchCategory]
    func createCategory(name: String) async throws -> Int
    
    func objectsCD() -> AnyPublisher<[FetchObject], Never>
    func deleteCD(id: Int) async throws
    func createCD(object: FetchObject) async throws -> Int
}

final class MovieCoreData: CoreDataProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createCD(object: Movie) async throws -> Int {
        let newMovie = CDMovie(context: context)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = formatter.string(from: Date())
        let nowAsID = Int(now) ?? 0
        newMovie.id = Int32(nowAsID)
        newMovie.title = object.title
        newMovie.my_review = object.myReview
        newMovie.rating = object.rating
        newMovie.imdb_link = object.imdbLink
        newMovie.release_year = object.releaseYear

        let category = try await movieCategoryCD(cat: object.category)
        
        newMovie.category = category
        save()
        return nowAsID
    }
    
    private
    func movieCategoryCD(cat: Category) async throws -> CDMovieCategory? {
        let request = CDMovieCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", cat.id as CVarArg)
        if let result = try? context.fetch(request).first {
            return result
        } else {
            return try await createCategoryCD(cat: cat)
        }
    }
    
    private
    func createCategoryCD(cat: Category) async throws -> CDMovieCategory {
        let newCat = CDMovieCategory(context: context)
        newCat.id = Int16(cat.id)
        newCat.name = cat.name
        save()
        return newCat
    }
    
    func objectsCD() -> AnyPublisher<[Movie], Never> {
        let requestCD = CDMovie.fetchRequest()
        
        return context.fetchPublisher(requestCD)
            .tryMap { entities in
                try entities.map({ try Movie(from: $0) })
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func deleteCD(id: Int) async throws {
        let request = CDMovie.fetchRequest()
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

final class MovieRepository: RepositoryProtocol {
    private let coreData: MovieCoreData
    
    init(coreData: MovieCoreData) {
        self.coreData = coreData
    }
    func fetch(for page: Int, categoryId: Int?) async throws -> ItemsObject<Movie> {
        let moviesEndpoint = MoviesEndpoint.list(page, categoryId)
        return try await SwiftServices.shared.request(endpoint: moviesEndpoint)
    }
    
    func create(object: Movie) async throws -> Int {
        let moviesEndpoint = MoviesEndpoint.add(object)
        let newMovieIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: moviesEndpoint)
        return newMovieIdObj.id
    }
    
    func delete(for ids: [Int]) async throws {
        let moviesEndpoint = MoviesEndpoint.delete(ids)
        return try await SwiftServices.shared.request(endpoint: moviesEndpoint)
    }

    func fetchCategories() async throws -> [Category] {
        let moviesEndpoint = MoviesEndpoint.categories
        return try await SwiftServices.shared.request(endpoint: moviesEndpoint)
    }
    
    func createCategory(name: String) async throws -> Int {
        let moviesEndpoint = MoviesEndpoint.addCategory(name)
        let newMovieIdObj: NewObjectId = try await SwiftServices.shared.request(endpoint: moviesEndpoint)
        return newMovieIdObj.id
    }
    
    func deleteCategories(for ids: [Int]) async throws {
        let movieDeletionEndpoint = MoviesEndpoint.deleteCategories(ids)
        return try await SwiftServices.shared.request(endpoint: movieDeletionEndpoint)
    }
    
    func objectsCD() -> AnyPublisher<[Movie], Never> {
        coreData.objectsCD()
    }
    
    func deleteCD(id: Int) async throws {
        try await coreData.deleteCD(id: id)
    }
    
    func createCD(object: Movie) async throws -> Int {
        return try await coreData.createCD(object: object)
    }
}
