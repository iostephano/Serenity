//
//  PlanOfDayCard.swift
//  Serenity
//
//  Created by Stephano Portella on 13/08/25.
//

import SwiftUI

/// Tarjeta "plan del día". El corazón de recordatorio y las franjas horarias son
/// interacción local sin efecto: no programan nada ni se guardan (ver README).
struct PlanOfDayCard: View {
    var cardHeight: CGFloat = 240
    var corner: CGFloat = 26

    @State private var reminderOn = false
    @State private var selectedSlots: Set<Slot> = []

    enum Slot: String, CaseIterable, Identifiable {
        case manana = "Mañana"
        case tarde = "Tarde"
        case noche = "Noche"

        var id: String { rawValue }
        var icon: String {
            switch self {
            case .manana: "sun.max.fill"
            case .tarde: "clock"
            case .noche: "moon.stars.fill"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Plan del día")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.92))

                Spacer()

                Button {
                    reminderOn.toggle()
                } label: {
                    Image(systemName: reminderOn ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(reminderOn ? DSColor.primary : .white.opacity(0.9))
                        .padding(8)
                        .background(.white.opacity(0.08), in: .circle)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Recordatorio")
                .accessibilityValue(reminderOn ? "Activado" : "Desactivado")
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(Slot.allCases) { slot in
                    slotRow(slot, selected: selectedSlots.contains(slot))
                        .onTapGesture {
                            if selectedSlots.contains(slot) { selectedSlots.remove(slot) }
                            else { selectedSlots.insert(slot) }
                        }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .frame(height: cardHeight)
        .background(.black.opacity(0.28), in: RoundedRectangle(cornerRadius: corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func slotRow(_ slot: Slot, selected: Bool) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(selected ? DSColor.primary : .white.opacity(0.10))
                    .frame(width: 30, height: 30)
                Image(systemName: slot.icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(selected ? .black : .white.opacity(0.85))
            }

            Text(slot.rawValue)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(selected ? .black : .white.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 4)

            Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(selected ? .black : .white.opacity(0.6))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(selected ? DSColor.primary : .white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(slot.rawValue)
        .accessibilityValue(selected ? "Seleccionado" : "No seleccionado")
    }
}
