//
//  Endpoints+Video.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 15/02/2026.
//

import Foundation

enum VideoEndpoint: Endpoint {
    case list(Int)
    case add(Video)
    case delete([Int])

    var path: String {
        switch self {
        case .list, .delete(_):
            return baseURLString + "videos"
        case .add:
            return baseURLString + "videos/create"
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
        case .list(let page):
            var query = ["page": page]
            return query
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
