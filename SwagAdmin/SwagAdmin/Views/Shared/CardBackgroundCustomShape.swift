//
//  CardCustomBackgroundView.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 11/02/2026.
//

import SwiftUI

struct CardBackgroundCustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 20
        let top = CGPoint(x: rect.maxX, y: rect.minY)
        let left = CGPoint(x: rect.minX, y: rect.maxY)
        let right = CGPoint(x: rect.maxX, y: rect.maxY)
        let mid = CGPoint(x: rect.minX, y: rect.midY)
        
        return Path { path in
            path.move(to: top)
            path.addArc(tangent1End: right,
                        tangent2End: left,
                        radius: cornerRadius)
            
            path.addArc(tangent1End: left,
                        tangent2End: mid,
                        radius: cornerRadius)

            path.addArc(tangent1End: mid,
                        tangent2End: top,
                        radius: cornerRadius * 3)
            
            path.addArc(tangent1End: top,
                        tangent2End: right,
                        radius: cornerRadius)

            path.closeSubpath()
        }
    }
}
