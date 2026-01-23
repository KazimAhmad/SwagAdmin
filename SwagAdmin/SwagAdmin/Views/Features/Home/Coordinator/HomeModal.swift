//
//  HomeModal.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import Foundation

enum HomeModal: Identifiable {
    case newThought(((Thought) -> Void)?)
    
    var id: String {
        switch self {
        case .newThought:
            return "newThought"
        }
    }
}

enum FullScreenModal: Identifiable {
    case alert(AlertConfig)
    case seeMore(SeeMoreConfig)
    var id: String {
        switch self {
        case .alert:
            return "alert"
        case .seeMore:
            return "seeMore"
        }
    }
}
