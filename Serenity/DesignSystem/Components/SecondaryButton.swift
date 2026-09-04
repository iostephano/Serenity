//
//  SecondaryButton.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(DSColor.glassText)
                .frame(minWidth: 160)
                .frame(height: 95)
                .background(.ultraThinMaterial, in:
                    RoundedRectangle(cornerRadius: 45, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 45, style: .continuous)
                        .stroke(DSColor.glassStroke, lineWidth: 1)
                )
                .overlay(
                    LinearGradient(colors: [Color.white.opacity(0.16), .clear],
                                   startPoint: .top, endPoint: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 45, style: .continuous))
                )
                .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 8)
        }
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(.isButton)
    }
}
