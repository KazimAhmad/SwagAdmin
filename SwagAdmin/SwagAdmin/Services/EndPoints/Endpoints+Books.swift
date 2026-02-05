//
//  Endpoints+Books.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 05/02/2026.
//

import Foundation

enum BooksEndpoint: Endpoint {
    case list(Int, Int?)
    case add(Book)
    case delete([Int])
    case categories
    case addCategory(String)
    case deleteCategories([Int])

    var path: String {
        switch self {
        case .list, .delete(_):
            return baseURLString + "books"
        case .add:
            return baseURLString + "books/create"
        case .addCategory:
            return baseURLString + "books/category/create"
        case .categories, .deleteCategories:
            return baseURLString + "books/categories"
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
        case .add(let book):
            return HTTPBody.json(book)
        case .addCategory(let name):
            return HTTPBody.json(["name": name])
        default:
            return nil
        }
    }
}
