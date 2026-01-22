//
//  ViewState.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import Foundation

enum ViewState: Equatable {
    case loading
    case info
    case error(Error)
    case empty
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.info, .info):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.empty, .empty):
            return true
        default:
            return false
        }
    }
}
