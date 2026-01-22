//
//  HTTPMethod.swift
//  SwiftServices
//
//  Created by Kazim Ahmad on 23/12/2025.
//

import Foundation

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var query: [String: Any]? { get }
    var body: HTTPBody? { get }
}
