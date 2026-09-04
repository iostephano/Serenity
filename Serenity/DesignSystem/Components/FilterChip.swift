//
//  FilterChip.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    var isSelected: Bool
    var badge: Int? = nil
    let action: () -> Void

    private var selectedBg: Color { DSColor.primary }
    private var selectedFg: Color { .black }
    private var normalBg: Color  { .white.opacity(0.08) }
    private var normalFg: Color  { .white.opacity(0.90) }
    private var stroke: Color    { .white.opacity(0.10) }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let badge {
                    Text("\(badge)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isSelected ? selectedFg.opacity(0.85) : normalFg)
                        .padding(6)
                        .background(
                            Circle()
                                .fill(isSelected ? selectedFg.opacity(0.12) : .white.opacity(0.12))
                        )
                }

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? selectedFg : normalFg)
                    .lineLimit(1)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? selectedBg : normalBg)
            )
            .overlay(
                Capsule()
                    .stroke(stroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(Text(isSelected ? "Seleccionado" : "No seleccionado"))
    }
}
