//
//  PlanCard.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

/// Tarjeta ancha "meditación para dormir": fondo nocturno con una luz cálida que
/// se desplaza. El botón de play es **solo visual** (ver README).
struct SleepPlanCard: View {
    @State private var isPlaying = false
    @State private var lampAtText = false

    private let nightTop = Color(red: 0.05, green: 0.07, blue: 0.12)
    private let nightBottom = Color(red: 0.01, green: 0.02, blue: 0.04)
    private let lamp = Color(red: 1.00, green: 0.82, blue: 0.45)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [nightTop, nightBottom],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.6), radius: 16, x: 0, y: 6)

            GeometryReader { geo in
                let start = CGPoint(x: geo.size.width - 36, y: geo.size.height * 0.56)
                let end = CGPoint(x: geo.size.width * 0.36, y: geo.size.height * 0.25)

                ZStack {
                    Circle().fill(lamp.opacity(0.35))
                        .frame(width: 220, height: 220)
                        .blur(radius: 40)
                    Circle().stroke(lamp.opacity(0.25), lineWidth: 18)
                        .frame(width: 160, height: 160)
                        .blur(radius: 30)
                }
                .blendMode(.screen)
                .position(lampAtText ? end : start)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: lampAtText)
                .onAppear { lampAtText = true }
                .allowsHitTesting(false)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Meditación para dormir profundo")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 8) {
                    TagChip("10 min")
                    TagChip("Sueño")
                    TagChip("Noche")
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            isPlaying.toggle()
                        }
                    } label: {
                        PlayPauseCircle(isPlaying: isPlaying, size: 44)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isPlaying ? "Pausar" : "Reproducir")
                }
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

/// Círculo de play/pausa reutilizado por varias tarjetas.
struct PlayPauseCircle: View {
    let isPlaying: Bool
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(isPlaying ? DSColor.primary : .white.opacity(0.92))
                .frame(width: size, height: size)
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: size * 0.36, weight: .bold))
                .foregroundStyle(.black)
                .offset(x: isPlaying ? 0 : 1)
        }
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }
}
