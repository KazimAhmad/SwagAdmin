//
//  Endpoints+Facts.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 01/02/2026.
//

import Foundation

enum FactsEndpoint: Endpoint {
    case list(Int)
    case add(FunFact)
    case delete([Int])
    case categories
    case addCategory(String)
    
    var path: String {
        switch self {
        case .list, .delete(_):
            return baseURLString + "facts"
        case .add:
            return baseURLString + "facts/create"
        case .addCategory:
            return baseURLString + "facts/category/create"
        case .categories:
            return baseURLString + "facts/categories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .categories:
            return .get
        case .add, .addCategory:
            return .post
        case .delete(_):
            return .delete
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var query: [String: Any]? {
        switch self {
        case .list(let page):
            return ["page": page]
        default:
            return nil
        }
    }
    
    var body: HTTPBody? {
        switch self {
        case .delete(let ids):
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
