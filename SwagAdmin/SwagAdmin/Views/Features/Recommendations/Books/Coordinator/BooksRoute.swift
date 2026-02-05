//
//  RecommendationRoute.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 04/02/2026.
//

import Foundation

enum BooksRoute: Hashable {
    case books
}

enum BooksSheet: Identifiable {
    case new([Category], ((Book) -> Void)?)
    
    var id: Int {
        switch self {
        case .new:
            return 1
        }
    }
}

enum BooksFullScreenCover: Identifiable {
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
