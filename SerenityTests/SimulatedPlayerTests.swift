//
//  SimulatedPlayerTests.swift
//  SerenityTests
//
//  Created by Stephano Portella on 03/09/26.
//

import Testing
@testable import Serenity

@MainActor
struct SimulatedPlayerTests {

    private func track(minutes: Int = 5) -> Track {
        Track(title: "T", subtitle: "s", minutes: minutes, category: .meditacion, coverSeed: 1)
    }

    @Test("Nothing plays before calling play")
    func startsIdle() {
        let player = SimulatedPlayer()
        #expect(!player.isPlaying)
        #expect(player.currentTime == 0)
        #expect(player.duration == 0)
    }

    @Test("Playing sets the duration from the track and starts at zero")
    func playSetsDuration() {
        let player = SimulatedPlayer()
        player.play(track(minutes: 3))
        #expect(player.isPlaying)
        #expect(player.duration == 180)
        #expect(player.currentTime == 0)
    }

    @Test("advance moves the clock forward while playing")
    func advanceMovesForward() {
        let player = SimulatedPlayer()
        player.play(track(minutes: 10))
        player.advance(by: 30)
        #expect(player.currentTime == 30)
        #expect(abs(player.progress - (30.0 / 600.0)) < 0.0001)
    }

    @Test("advance does nothing while paused")
    func advanceIgnoredWhilePaused() {
        let player = SimulatedPlayer()
        player.play(track(minutes: 10))
        player.toggle() // pause
        player.advance(by: 30)
        #expect(player.currentTime == 0)
    }

    @Test("Without loop, reaching the end stops and pins the time")
    func endStopsWithoutLoop() {
        let player = SimulatedPlayer()
        player.play(track(minutes: 1)) // 60 s
        player.advance(by: 90)
        #expect(player.currentTime == 60)
        #expect(!player.isPlaying)
    }

    @Test("With loop, reaching the end wraps back to zero and keeps playing")
    func endWrapsWithLoop() {
        let player = SimulatedPlayer()
        player.isLooping = true
        player.play(track(minutes: 1))
        player.advance(by: 65)
        #expect(player.currentTime == 0)
        #expect(player.isPlaying)
    }

    @Test("seek(by:) clamps at both ends")
    func seekByClamps() {
        let player = SimulatedPlayer()
        player.play(track(minutes: 2)) // 120 s
        player.seek(by: -30)
        #expect(player.currentTime == 0)
        player.seek(by: 999)
        #expect(player.currentTime == 120)
    }

    @Test("seek(toFraction:) maps 0...1 onto the duration and clamps")
    func seekToFraction() {
        let player = SimulatedPlayer()
        player.play(track(minutes: 4)) // 240 s
        player.seek(toFraction: 0.5)
        #expect(player.currentTime == 120)
        player.seek(toFraction: 2)
        #expect(player.currentTime == 240)
        player.seek(toFraction: -1)
        #expect(player.currentTime == 0)
    }

    @Test("Playing the same track again does not reset its position")
    func replaySameTrackKeepsPosition() {
        let player = SimulatedPlayer()
        let t = track(minutes: 5)
        player.play(t)
        player.advance(by: 40)
        player.play(t)
        #expect(player.currentTime == 40)
    }
}
