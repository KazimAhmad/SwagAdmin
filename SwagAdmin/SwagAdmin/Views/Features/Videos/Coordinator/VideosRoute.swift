//
//  SettingsRoute.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 30/01/2026.
//

import Foundation

enum VideosRoute: Hashable {
    case videos
}

enum VideosSheet: Identifiable {
    case new(((Video) -> Void)?)
    
    var id: String {
        switch self {
        case .new:
            return "new"
        }
    }
}

enum VideosFullScreen: Identifiable {
    case alert(AlertConfig)
    var id: String {
        switch self {
        case .alert:
            return "alert"
        }
    }
}
