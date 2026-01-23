//
//  AppTypography.swift
//  Swag
//
//  Created by Kazim Ahmad on 15/01/2026.
//

import SwiftUI

enum AppTypography {
    static func title(size: CGFloat) -> Font {
        Font.custom("Limelight-Regular",
                    size: size,
                    relativeTo: .title)
    }
}

extension AppTypography {
    static func body(size: CGFloat) -> Font {
        Font.custom("ShadowsIntoLight",
                    size: size,
                    relativeTo: .title)
    }
}

extension AppTypography {
    static func note(size: CGFloat) -> Font {
        Font.custom("Pompiere-Regular",
                    size: size,
                    relativeTo: .title)
    }
}
