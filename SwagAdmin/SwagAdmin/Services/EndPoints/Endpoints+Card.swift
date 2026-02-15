//
//  Endpoints+Card.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 15/02/2026.
//

import Foundation

enum CardEndpoint: Endpoint {
    case list
    case add(Card)
    case delete([Int])

    var path: String {
        switch self {
        case .list, .delete(_):
            return baseURLString + "cards"
        case .add:
            return baseURLString + "cards/create"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .add:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var query: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var body: HTTPBody? {
        switch self {
        case .delete(let ids):
            return HTTPBody.json(["ids": ids])
        case .add(let video):
            return HTTPBody.json(video)
        default:
            return nil
        }
    }
}
