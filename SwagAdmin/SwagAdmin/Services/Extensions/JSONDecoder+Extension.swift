//
//  SwagApp.swift
//  Swag
//
//  Created by Kazim Ahmad on 13/01/2026.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static let customDate = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let formattedFullDate = Formatter.iso8601Format.date(from: string) {
            return formattedFullDate
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

class DateConverter {
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
}

extension Formatter {
    static let iso8601Format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = DateConverter.dateFormat
        return formatter
    }()
}
