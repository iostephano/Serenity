//
//  Track.swift
//  Serenity
//
//  Created by Stephano Portella on 13/08/25.
//

import Foundation

enum TrackCategory: String, CaseIterable, Codable, Identifiable, Sendable {
    case mantras = "Mantras"
    case meditacion = "Meditación"
    case sueno = "Sueño"

    var id: String { rawValue }
}

struct Track: Identifiable, Equatable, Hashable, Sendable {
    let id: UUID
    let title: String
    let subtitle: String
    let minutes: Int
    let category: TrackCategory
    /// Semilla para generar la portada procedural (ver `CoverArt`).
    let coverSeed: Int

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        minutes: Int,
        category: TrackCategory,
        coverSeed: Int
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.minutes = minutes
        self.category = category
        self.coverSeed = coverSeed
    }

    var durationText: String { "\(minutes) min" }
    var totalSeconds: Double { Double(max(1, minutes) * 60) }
}
