//
//  MiniPlayerView.swift
//  Serenity
//
//  Created by Stephano Portella on 13/08/25.
//

import SwiftUI

/// Reproductor compacto anclado abajo. Muestra la pista actual, una barra de
/// progreso arrastrable y los controles de transporte. No suena audio: el tiempo
/// lo lleva `SimulatedPlayer` (ver README).
struct MiniPlayerView: View {
    let track: Track
    let isPlaying: Bool
    let isLooping: Bool
    let progress: Double
    let currentTime: Double
    let duration: Double

    let onBack: () -> Void
    let onToggle: () -> Void
    let onForward: () -> Void
    let onScrub: (Double) -> Void
    let onToggleLoop: () -> Void

    var height: CGFloat = 92

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                CoverArt(category: track.category, seed: track.coverSeed, cornerRadius: 10)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(track.subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.75))
                        .lineLimit(1)
                }

                Spacer()

                Button(action: onToggleLoop) {
                    Image(systemName: "repeat")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isLooping ? DSColor.primary : .white.opacity(0.85))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Repetir")
                .accessibilityValue(isLooping ? "Activado" : "Desactivado")
            }

            VStack(spacing: 2) {
                ProgressSlider(value: progress, onChanged: onScrub)
                    .padding(.vertical, 2)
                HStack {
                    Text(Self.timeText(currentTime))
                    Spacer()
                    Text(Self.timeText(duration))
                }
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.7))
            }

            HStack(spacing: 22) {
                Button(action: onBack) {
                    Image(systemName: "gobackward.15").font(.system(size: 18, weight: .semibold))
                }
                .accessibilityLabel("Retroceder 15 segundos")

                Button(action: onToggle) {
                    ZStack {
                        Circle().fill(isPlaying ? DSColor.primary : .white).frame(width: 40, height: 40)
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black)
                            .offset(x: isPlaying ? 0 : 1)
                    }
                }
                .accessibilityLabel(isPlaying ? "Pausar" : "Reproducir")

                Button(action: onForward) {
                    Image(systemName: "goforward.15").font(.system(size: 18, weight: .semibold))
                }
                .accessibilityLabel("Avanzar 15 segundos")
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(minHeight: height)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(Color.black.opacity(0.1).allowsHitTesting(false))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.28), radius: 10, x: 0, y: 6)
    }

    static func timeText(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds > 0 else { return "0:00" }
        let total = Int(seconds)
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}

private struct ProgressSlider: View {
    var value: Double
    var onChanged: (Double) -> Void

    private let thumb: CGFloat = 18
    private let line: CGFloat = 3
    @State private var dragValue: Double?

    var body: some View {
        GeometryReader { geo in
            let width = max(1, geo.size.width - thumb)
            let x = CGFloat(dragValue ?? value) * width

            ZStack(alignment: .leading) {
                Capsule().fill(.white.opacity(0.2)).frame(height: line)
                Capsule().fill(.white).frame(width: max(0, x), height: line)
                Circle()
                    .fill(.white)
                    .frame(width: thumb, height: thumb)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                    .offset(x: x)
            }
            .frame(height: max(thumb, line))
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        let clamped = min(max(0, g.location.x - thumb / 2), width)
                        let fraction = Double(clamped / width)
                        dragValue = fraction
                        onChanged(fraction)
                    }
                    .onEnded { _ in dragValue = nil }
            )
        }
        .frame(height: max(thumb, line))
    }
}
