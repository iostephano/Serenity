//
//  MeditationService.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import Foundation

protocol MeditationServiceProtocol: Sendable {
    /// Devuelve las pistas de una categoría.
    func tracks(for category: TrackCategory) -> [Track]
}
