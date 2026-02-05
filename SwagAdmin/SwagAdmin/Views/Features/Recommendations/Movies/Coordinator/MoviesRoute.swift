//
//  RecommendationRoute.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 04/02/2026.
//

import Foundation

enum MoviesRoute: Hashable {
    case movie
}

enum MoviesSheet: Identifiable {
    case new([Category], ((Movie) -> Void)?)
    
    var id: Int {
        switch self {
        case .new:
            return 1
        }
    }
}

enum MoviesFullScreenCover: Identifiable {
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
