//
//  CoverArt.swift
//  Serenity
//
//  Created by Stephano Portella on 03/09/26.
//

import SwiftUI
import UIKit

/// Portada procedural: un degradado de dos capas cuya paleta depende de la
/// categoría y cuyo ángulo y "brillo" varían con la semilla de la pista. Sustituye
/// a las imágenes de portada (el repo no incluye ninguna).
struct CoverArt: View {
    let category: TrackCategory
    let seed: Int

    var cornerRadius: CGFloat = 12

    var body: some View {
        let palette = Palette.forCategory(category)
        // La semilla desplaza ligeramente el tono y el ángulo, para que dos
        // portadas de la misma categoría no sean idénticas.
        let hueShift = Double((seed % 7) - 3) * 0.02
        let angle = Double((seed * 53) % 360)

        ZStack {
            LinearGradient(
                colors: palette.gradient.map { $0.shiftingHue(by: hueShift) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            AngularGradient(
                colors: [palette.accent.opacity(0.0), palette.accent.opacity(0.7), palette.accent.opacity(0.0)],
                center: UnitPoint(x: 0.5 + hueShift * 4, y: 0.5),
                angle: .degrees(angle)
            )
            .blendMode(.plusLighter)
            .opacity(0.6)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }

    struct Palette {
        let gradient: [Color]
        let accent: Color

        static func forCategory(_ category: TrackCategory) -> Palette {
            switch category {
            case .mantras:
                Palette(
                    gradient: [Color(hue: 0.09, saturation: 0.55, brightness: 0.85),
                               Color(hue: 0.03, saturation: 0.60, brightness: 0.45)],
                    accent: Color(hue: 0.11, saturation: 0.7, brightness: 1.0)
                )
            case .meditacion:
                Palette(
                    gradient: [Color(hue: 0.42, saturation: 0.45, brightness: 0.70),
                               Color(hue: 0.55, saturation: 0.55, brightness: 0.35)],
                    accent: Color(hue: 0.35, saturation: 0.6, brightness: 0.95)
                )
            case .sueno:
                Palette(
                    gradient: [Color(hue: 0.66, saturation: 0.55, brightness: 0.55),
                               Color(hue: 0.72, saturation: 0.65, brightness: 0.22)],
                    accent: Color(hue: 0.61, saturation: 0.5, brightness: 0.9)
                )
            }
        }
    }
}

private extension Color {
    /// Rota el tono un pequeño delta manteniendo saturación y brillo.
    func shiftingHue(by delta: Double) -> Color {
        let ui = UIColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard ui.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return self }
        let shifted = (Double(h) + delta).truncatingRemainder(dividingBy: 1)
        return Color(hue: shifted < 0 ? shifted + 1 : shifted, saturation: Double(s), brightness: Double(b), opacity: Double(a))
    }
}
