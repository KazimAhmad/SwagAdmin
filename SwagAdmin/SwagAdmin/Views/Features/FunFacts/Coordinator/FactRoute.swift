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
    case new([FunFactCategory], ((FunFact) -> Void)?)
    
    var id: Int {
        switch self {
        case .new:
            return 1
        }
    }
}

enum FactFullScreenCover: Identifiable {
    case seeMore(SeeMoreConfig)
    case categories(CategoriesConfig)
    case alert(AlertConfig)
    
    var id: Int {
        switch self {
        case .seeMore:
            return 1
            case .categories:
            return 2
        case .alert:
            return 3
        }
    }
}
