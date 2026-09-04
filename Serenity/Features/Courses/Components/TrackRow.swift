//
//  TrackRow.swift
//  Serenity
//
//  Created by Stephano Portella on 13/08/25.
//

import SwiftUI

struct TrackRow: View {
    let track: Track
    let isPlaying: Bool
    let onPlay: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CoverArt(category: track.category, seed: track.coverSeed)
                .frame(width: 46, height: 46)

            VStack(alignment: .leading, spacing: 2) {
                Text(track.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text("\(track.durationText) • \(track.subtitle)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }

            Spacer()

            Button(action: onPlay) {
                PlayPauseCircle(isPlaying: isPlaying, size: 36)
                    .shadow(color: .clear, radius: 0)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isPlaying ? "Pausar" : "Reproducir")
        }
        .padding(12)
        .background(.black.opacity(0.28), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}
