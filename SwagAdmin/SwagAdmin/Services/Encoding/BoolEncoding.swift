//
//  SwagApp.swift
//  Swag
//
//  Created by Kazim Ahmad on 13/01/2026.
//

import Foundation

public enum BoolEncoding {
    case numeric, literal

    func encode(value: Bool) -> String {
        switch self {
        case .numeric:
            return value ? "1" : "0"
        case .literal:
            return value ? "true" : "false"
        }
    }
}
