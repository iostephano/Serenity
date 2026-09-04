//
//  CoursesViewModel.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import Observation

@Observable
@MainActor
final class CoursesViewModel {

    let player = SimulatedPlayer()

    private let service: MeditationServiceProtocol
    private(set) var currentTrack: Track?
    var selectedCategory: TrackCategory?

    init(service: MeditationServiceProtocol) {
        self.service = service
    }

    // MARK: - Filtros

    func selectAll() { selectedCategory = nil }
    func select(_ category: TrackCategory) { selectedCategory = category }

    func tracks(for category: TrackCategory) -> [Track] {
        service.tracks(for: category)
    }

    // MARK: - Reproductor

    func play(_ track: Track) {
        if currentTrack?.id == track.id {
            player.toggle()
        } else {
            currentTrack = track
            player.play(track)
            player.seek(toFraction: 0)
        }
    }

    func isNowPlaying(_ track: Track) -> Bool {
        currentTrack?.id == track.id && player.isPlaying
    }

    func togglePlay() { player.toggle() }
    func seekBack() { player.seek(by: -15) }
    func seekForward() { player.seek(by: 15) }
    func setProgress(_ fraction: Double) { player.seek(toFraction: fraction) }
    func toggleLoop() { player.isLooping.toggle() }
}
