//
//  SleepMeditationPromoCard.swift
//  Serenity
//
//  Created by Stephano Portella on 13/08/25.
//

import SwiftUI

/// Tarjeta promocional del dashboard. El botón de play es **solo visual** (ver
/// README): alterna el icono pero no reproduce nada.
struct SleepMeditationPromoCard: View {
    @State private var isPlaying = false

    private let height: CGFloat = 240
    private let corner: CGFloat = 26

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hue: 0.22, saturation: 0.9, brightness: 0.9),
                            Color(hue: 0.22, saturation: 0.70, brightness: 0.55)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 6) {
                Text("Empezar rápido")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
                Text("Meditación\npara dormir")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineSpacing(1)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) { isPlaying.toggle() }
                    } label: {
                        PlayPauseCircle(isPlaying: isPlaying, size: 48).padding(14)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isPlaying ? "Pausar" : "Reproducir")
                }
            }
        }
        .frame(height: height)
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        )
    }
}
