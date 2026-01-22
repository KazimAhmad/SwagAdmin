//
//  SwagApp.swift
//  Swag
//
//  Created by Kazim Ahmad on 13/01/2026.
//

import Foundation

extension NSNumber {
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
