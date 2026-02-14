//
//  SettingsRoute.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 30/01/2026.
//

import Foundation

enum SettingsRoute: Hashable {
    case settings
    case draft(SettingsSection)
}

enum SettingsSheet: Identifiable {
    case newThought(Thought, ((Thought) -> Void)?, ((Thought) -> Void)?)
    case newCard(Card, ((Card) -> Void)?)
    
    var id: String {
        switch self {
        case .newThought:
            return "newThought"
        case .newCard:
            return "newCard"
        }
    }
}

enum SettingsFullScreen: Identifiable {
    case alert(AlertConfig)
    var id: String {
        switch self {
        case .alert:
            return "alert"
        }
    }
}
