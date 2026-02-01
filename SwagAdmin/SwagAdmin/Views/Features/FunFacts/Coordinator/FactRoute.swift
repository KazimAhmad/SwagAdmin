//
//  FactRoute.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 01/02/2026.
//

import Foundation

enum FactRoute: Hashable {
    case facts
}

enum FactSheet: Identifiable {
    case new
    
    var id: Int {
        switch self {
        case .new:
            return 1
        }
    }
}

enum FactFullScreenCover: Identifiable {
    case seeMore(SeeMoreConfig)
    
    var id: Int {
        switch self {
        case .seeMore:
            return 1
        }
    }
}
