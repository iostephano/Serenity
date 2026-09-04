//
//  MockMeditationService.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import Foundation

/// Catálogo de ejemplo: cinco pistas por categoría. Los datos están en código;
/// no hay red ni base de datos.
struct MockMeditationService: MeditationServiceProtocol {

    private let all: [Track] = {
        func make(_ title: String, _ subtitle: String, _ minutes: Int, _ category: TrackCategory, _ seed: Int) -> Track {
            Track(title: title, subtitle: subtitle, minutes: minutes, category: category, coverSeed: seed)
        }

        let mantras = [
            make("Mantra de la mañana", "Enfoque y claridad", 5, .mantras, 1),
            make("Canto de gratitud", "Energía positiva", 6, .mantras, 2),
            make("Mantra de compasión", "Calma y bondad", 7, .mantras, 3),
            make("Mantra de centrado", "Paz interior", 8, .mantras, 4),
            make("Mantra de la tarde", "Bajar el ritmo", 5, .mantras, 5)
        ]

        let meditacion = [
            make("Foco en la respiración", "Calma la mente", 10, .meditacion, 6),
            make("Escaneo corporal", "Enraízate", 12, .meditacion, 7),
            make("Paseo consciente", "Atención plena", 9, .meditacion, 8),
            make("Bondad amorosa", "Calidez y cuidado", 11, .meditacion, 9),
            make("Visualizar la calma", "Foco suave", 8, .meditacion, 10)
        ]

        let sueno = [
            make("Olas para dormir", "Déjate llevar", 15, .sueno, 11),
            make("Luz de luna", "Noche serena", 14, .sueno, 12),
            make("Descanso profundo", "Respiración lenta", 18, .sueno, 13),
            make("Noche estrellada", "Mente en silencio", 16, .sueno, 14),
            make("Lluvia suave", "Sueño tranquilo", 12, .sueno, 15)
        ]

        return mantras + meditacion + sueno
    }()

    func tracks(for category: TrackCategory) -> [Track] {
        all.filter { $0.category == category }
    }
}
