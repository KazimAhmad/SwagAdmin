//
//  Endpoints+Movies.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 03/02/2026.
//

import Foundation

enum MoviesEndpoint: Endpoint {
    case list(Int, Int?)
    case add(Movie)
    case delete([Int])
    case categories
    case addCategory(String)
    case deleteCategories([Int])

    var path: String {
        switch self {
        case .list, .delete(_):
            return baseURLString + "movies"
        case .add:
            return baseURLString + "movies/create"
        case .addCategory:
            return baseURLString + "movies/category/create"
        case .categories, .deleteCategories:
            return baseURLString + "movies/categories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .categories:
            return .get
        case .add, .addCategory:
            return .post
        case .delete, .deleteCategories:
            return .delete
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var query: [String: Any]? {
        switch self {
        case .list(let page, let categoryID):
            var query = ["page": page]
            if let categoryID = categoryID {
                query["category_id"] = categoryID
            }
            return query
        default:
            return nil
        }
    }
    
    var body: HTTPBody? {
        switch self {
        case .delete(let ids), .deleteCategories(let ids):
            return HTTPBody.json(["ids": ids])
        case .add(let movie):
            return HTTPBody.json(movie)
        case .addCategory(let name):
            return HTTPBody.json(["name": name])
        default:
            return nil
        }
    }
}
