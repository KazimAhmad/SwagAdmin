//
//  SettingsRoute.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 30/01/2026.
//

import Foundation

enum SettingsRoute: String {
    case settings
    case thoughts
}

enum SettingsSheet: Identifiable {
    case newThought(((Thought) -> Void)?)
    
    var id: String {
        switch self {
        case .newThought:
            return "newThought"
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
