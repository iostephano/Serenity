//
//  LotusMark.swift
//  Serenity
//
//  Created by Stephano Portella on 03/09/26.
//

import SwiftUI

/// Logo de la app: un loto de cinco pétalos dibujado con `Path` (antes era una
/// imagen). Se define en un espacio unitario y se escala al `frame` recibido, así
/// nunca se sale de sus límites.
struct LotusMark: View {
    var lineWidth: CGFloat = 2
    var color: Color = .white

    var body: some View {
        Lotus()
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))
            .accessibilityLabel("Serenity")
    }

    private struct Lotus: Shape {
        /// Cada pétalo: (ángulo desde la vertical, largo relativo).
        private let petals: [(angle: CGFloat, length: CGFloat)] = [
            (-62, 0.58), (-32, 0.84), (0, 1.0), (32, 0.84), (62, 0.58)
        ]

        func path(in rect: CGRect) -> Path {
            // Espacio unitario: base abajo-centro, pétalo más largo = 0.9 de alto.
            let base = CGPoint(x: 0.5, y: 0.96)
            let maxLength: CGFloat = 0.88
            let halfWidth: CGFloat = 0.2

            var unit = Path()
            for petal in petals {
                let angle = petal.angle * .pi / 180
                let length = maxLength * petal.length
                let tip = CGPoint(x: base.x + sin(angle) * length, y: base.y - cos(angle) * length)
                let normal = CGPoint(x: cos(angle), y: sin(angle))
                let mid = CGPoint(x: (base.x + tip.x) / 2, y: (base.y + tip.y) / 2)
                let left = CGPoint(x: mid.x - normal.x * halfWidth, y: mid.y - normal.y * halfWidth)
                let right = CGPoint(x: mid.x + normal.x * halfWidth, y: mid.y + normal.y * halfWidth)

                unit.move(to: base)
                unit.addQuadCurve(to: tip, control: left)
                unit.addQuadCurve(to: base, control: right)
            }

            return unit.applying(CGAffineTransform(scaleX: rect.width, y: rect.height))
                .offsetBy(dx: rect.minX, dy: rect.minY)
        }
    }
}

#Preview {
    LotusMark(lineWidth: 3)
        .frame(width: 120, height: 120)
        .padding(40)
        .background(.black)
}
