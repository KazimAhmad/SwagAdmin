//
//  Color+hex.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 11/02/2026.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.count == 6, let intVal = Int(hex, radix: 16) else { return nil }
        let r = Double((intVal >> 16) & 0xFF) / 255.0
        let g = Double((intVal >> 8) & 0xFF) / 255.0
        let b = Double(intVal & 0xFF) / 255.0
        self = Color(red: r, green: g, blue: b)
    }

    var hexString: String? {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #else
        return nil
        #endif
        let uiColor = NativeColor(self)
        guard let rgb = uiColor.cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil),
              let comps = rgb.components, comps.count >= 3 else { return nil }
        let r = Int(round(comps[0] * 255))
        let g = Int(round(comps[1] * 255))
        let b = Int(round(comps[2] * 255))
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
