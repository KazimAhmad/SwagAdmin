//
//  SwagApp.swift
//  Swag
//
//  Created by Kazim Ahmad on 13/01/2026.
//

import Foundation

//MARK: -To handle the Any type of query
public enum ArrayEncoding {
    case brackets, noBrackets

    func encode(key: String) -> String {
        switch self {
        case .brackets:
            return "\(key)[]"
        case .noBrackets:
            return key
        }
    }
}
