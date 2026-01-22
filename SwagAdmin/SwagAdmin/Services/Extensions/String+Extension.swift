//
//  SwagApp.swift
//  Swag
//
//  Created by Kazim Ahmad on 13/01/2026.
//

import Foundation

extension String {
    var addingPercentEncodingForURLFormValue: String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._* ")
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: " ", with: "+")
    }
}
