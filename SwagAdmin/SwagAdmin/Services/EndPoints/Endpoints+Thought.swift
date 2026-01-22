//
//  Endpoints+Thought.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 21/01/2026.
//

import Foundation

enum ThoughtEndpoint: Endpoint {
    case list(Int)
    case add(String, String?)
    case delete([Int])
    
    var path: String {
        switch self {
        case .list, .delete(_):
            return baseURLString + "thoughts"
        case .add:
            return baseURLString + "thoughts/create"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .add:
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
        case .add(let title, let more):
            if let more = more {
                return HTTPBody.json(["thought": title, "more": more])
            } else {
                return HTTPBody.json(["thought": title])
            }
        default:
            return nil
        }
    }
}
