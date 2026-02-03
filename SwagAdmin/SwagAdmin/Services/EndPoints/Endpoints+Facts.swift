//
//  Endpoints+Facts.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 01/02/2026.
//

import Foundation

enum FactsEndpoint: Endpoint {
    case list(Int, Int?)
    case add(FunFact)
    case delete([Int])
    case categories
    case addCategory(String)
    case deleteCategories([Int])

    var path: String {
        switch self {
        case .list, .delete(_):
            return baseURLString + "facts"
        case .add:
            return baseURLString + "facts/create"
        case .addCategory:
            return baseURLString + "facts/category/create"
        case .categories, .deleteCategories:
            return baseURLString + "facts/categories"
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
        case .add(let fact):
            return HTTPBody.json(fact)
        case .addCategory(let name):
            return HTTPBody.json(["name": name])
        default:
            return nil
        }
    }
}
