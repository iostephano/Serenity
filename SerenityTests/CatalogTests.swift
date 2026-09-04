//
//  CatalogTests.swift
//  SerenityTests
//
//  Created by Stephano Portella on 03/09/26.
//

import Testing
@testable import Serenity

struct CatalogTests {

    private let service = MockMeditationService()

    @Test("Every category has five tracks")
    func fivePerCategory() {
        for category in TrackCategory.allCases {
            #expect(service.tracks(for: category).count == 5)
        }
    }

    @Test("tracks(for:) only returns tracks of that category")
    func filterIsExact() {
        for category in TrackCategory.allCases {
            #expect(service.tracks(for: category).allSatisfy { $0.category == category })
        }
    }

    @Test("Cover seeds are unique across the whole catalog")
    func coverSeedsAreUnique() {
        let seeds = TrackCategory.allCases.flatMap { service.tracks(for: $0) }.map(\.coverSeed)
        #expect(Set(seeds).count == seeds.count)
    }

    @Test("Duration text and total seconds agree with the minutes")
    func durationDerivation() {
        let track = Track(title: "x", subtitle: "y", minutes: 12, category: .sueno, coverSeed: 99)
        #expect(track.durationText == "12 min")
        #expect(track.totalSeconds == 720)
    }

    @Test("A zero-minute track still has a positive duration")
    func zeroMinutesIsSafe() {
        let track = Track(title: "x", subtitle: "y", minutes: 0, category: .mantras, coverSeed: 1)
        #expect(track.totalSeconds >= 1)
    }
}

@MainActor
struct CoursesViewModelTests {

    @Test("Selecting a category and clearing it round-trips")
    func filterRoundTrip() {
        let vm = CoursesViewModel(service: MockMeditationService())
        #expect(vm.selectedCategory == nil)
        vm.select(.sueno)
        #expect(vm.selectedCategory == .sueno)
        vm.selectAll()
        #expect(vm.selectedCategory == nil)
    }

    @Test("Playing a new track makes it the current one and starts from zero")
    func playNewTrack() {
        let vm = CoursesViewModel(service: MockMeditationService())
        let track = vm.tracks(for: .mantras)[0]
        vm.play(track)
        #expect(vm.currentTrack == track)
        #expect(vm.isNowPlaying(track))
        #expect(vm.player.currentTime == 0)
    }

    @Test("Playing the current track again toggles pause")
    func replayTogglesPause() {
        let vm = CoursesViewModel(service: MockMeditationService())
        let track = vm.tracks(for: .mantras)[0]
        vm.play(track)
        vm.play(track)
        #expect(!vm.isNowPlaying(track))
    }
}
