//
//  SwagApp.swift
//  Swag
//
//  Created by Kazim Ahmad on 13/01/2026.
//

import Foundation

protocol SwiftServicesProtocol {
    var session: URLSession { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var errorType: (Codable & Error).Type? { get }
    
    func request<T: Decodable>(endpoint: Endpoint,
                               validate: Range<Int>,
                               cachePolicy: URLRequest.CachePolicy?,
                               retry: Bool) async throws -> T
    
    func request(endpoint: Endpoint,
                 validate: Range<Int>,
                 retry: Bool) async throws
    
    //MARK: -Interceptor to do stuff right before request is going through
    func willSendRequest(_ request: inout URLRequest) async throws
    //MARK: -In case of retry if an error occurs
    func shouldRetry(withError error: Error) async -> Bool
    
    func didReceiveData(_ data: inout Data, request: URLRequest) async throws
}
