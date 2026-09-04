//
//  AudioPlayerService.swift
//  Serenity
//
//  Created by Stephano Portella on 13/08/25.
//

import Foundation
import Observation

/// Reproductor **simulado**: no reproduce audio. Avanza un reloj con un bucle
/// `async` para poder mostrar progreso, seek y loop en la interfaz. La lógica de
/// tiempo (avance, límites, fin de pista, bucle) es lo que cubren las pruebas.
@Observable
@MainActor
final class SimulatedPlayer {

    private(set) var currentTrackID: UUID?
    private(set) var isPlaying = false
    private(set) var currentTime: Double = 0
    private(set) var duration: Double = 0
    var isLooping = false

    /// Fracción reproducida, 0...1.
    var progress: Double { duration > 0 ? currentTime / duration : 0 }

    private var ticker: Task<Void, Never>?
    private let tick: Double = 0.05

    // MARK: - Transporte

    func play(_ track: Track) {
        if currentTrackID != track.id {
            currentTrackID = track.id
            duration = track.totalSeconds
            currentTime = 0
        }
        isPlaying = true
        startTicker()
    }

    func toggle() {
        isPlaying.toggle()
        isPlaying ? startTicker() : stopTicker()
    }

    func seek(by seconds: Double) {
        currentTime = (currentTime + seconds).clamped(to: 0...max(0, duration))
    }

    func seek(toFraction fraction: Double) {
        currentTime = fraction.clamped(to: 0...1) * duration
    }

    // MARK: - Reloj

    /// Aplica un avance de `delta` segundos. Aislado para que las pruebas puedan
    /// ejercer la lógica de tiempo sin depender del reloj real.
    func advance(by delta: Double) {
        guard isPlaying, duration > 0 else { return }
        currentTime += delta
        if currentTime >= duration {
            if isLooping {
                currentTime = 0
            } else {
                currentTime = duration
                isPlaying = false
                stopTicker()
            }
        }
    }

    private func startTicker() {
        stopTicker()
        ticker = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.05))
                guard let self else { return }
                self.advance(by: self.tick)
                if !self.isPlaying { return }
            }
        }
    }

    private func stopTicker() {
        ticker?.cancel()
        ticker = nil
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
