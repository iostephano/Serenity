//
//  CoursesView.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

struct CoursesView: View {
    @State var viewModel: CoursesViewModel

    private let side: CGFloat = 20
    private let dashboardCardWidth: CGFloat = 180
    private let filters: [TrackCategory?] = [nil] + TrackCategory.allCases.map { $0 }

    private var showMiniPlayer: Bool {
        viewModel.selectedCategory != nil && viewModel.currentTrack != nil
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            GradientBackground(style: .courses)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    LotusMark(lineWidth: 2)
                        .frame(width: 50, height: 50)
                        .opacity(0.92)

                    Text(viewModel.selectedCategory?.rawValue ?? "Empezar rápido")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.95))
                        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedCategory)

                    HStack(spacing: 10) {
                        ForEach(filters, id: \.self) { filter in
                            FilterChip(
                                title: filter?.rawValue ?? "Todas",
                                isSelected: viewModel.selectedCategory == filter
                            ) {
                                if let category = filter { viewModel.select(category) }
                                else { viewModel.selectAll() }
                            }
                        }
                    }

                    content

                    Spacer(minLength: showMiniPlayer ? 130 : 24)
                }
                .padding(.horizontal, side)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .overlay(alignment: .bottom) {
            if showMiniPlayer, let track = viewModel.currentTrack {
                MiniPlayerView(
                    track: track,
                    isPlaying: viewModel.player.isPlaying,
                    isLooping: viewModel.player.isLooping,
                    progress: viewModel.player.progress,
                    currentTime: viewModel.player.currentTime,
                    duration: viewModel.player.duration,
                    onBack: { viewModel.seekBack() },
                    onToggle: { viewModel.togglePlay() },
                    onForward: { viewModel.seekForward() },
                    onScrub: { viewModel.setProgress($0) },
                    onToggleLoop: { viewModel.toggleLoop() }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showMiniPlayer)
    }

    @ViewBuilder
    private var content: some View {
        if let category = viewModel.selectedCategory {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.tracks(for: category)) { track in
                    TrackRow(
                        track: track,
                        isPlaying: viewModel.isNowPlaying(track)
                    ) {
                        viewModel.play(track)
                    }
                }
            }
            .padding(.top, 8)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        } else {
            HStack(alignment: .top, spacing: 12) {
                PlanOfDayCard().frame(width: dashboardCardWidth)
                SleepMeditationPromoCard().frame(width: dashboardCardWidth)
            }
            .padding(.top, 4)

            AffirmationsCard().padding(.top, 4)
            SleepPlanCard().padding(.top, 8)
        }
    }
}

/// Tarjeta de afirmaciones del dashboard. Los chips y el botón de play son
/// interacción local sin efecto (ver README).
private struct AffirmationsCard: View {
    @State private var isPlaying = false
    @State private var animate = false
    @State private var selected: Set<String> = []

    private let chips = ["15 min", "Tarde", "Relax"]
    private let sunsetA = Color(red: 1.00, green: 0.51, blue: 0.20)
    private let sunsetB = Color(red: 1.00, green: 0.39, blue: 0.47)
    private let sunsetC = Color(red: 0.53, green: 0.34, blue: 0.76)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.black.opacity(0.25))

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [sunsetA.opacity(0.22), sunsetB.opacity(0.18), sunsetC.opacity(0.22)],
                        startPoint: animate ? .topLeading : .bottomTrailing,
                        endPoint: animate ? .bottomTrailing : .topLeading
                    )
                )
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
                .onAppear { animate = true }

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.06), lineWidth: 1)

            VStack(alignment: .leading, spacing: 14) {
                Text("Afirmaciones para cerrar el día")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(.white)

                HStack(spacing: 12) {
                    ForEach(chips, id: \.self) { tag in
                        let isOn = selected.contains(tag)
                        Button {
                            if isOn { selected.remove(tag) } else { selected.insert(tag) }
                        } label: {
                            Text(tag)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(isOn ? .black : .white.opacity(0.95))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(isOn ? DSColor.primary : .white.opacity(0.10)))
                                .overlay(Capsule().stroke(.white.opacity(0.10), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) { isPlaying.toggle() }
                    } label: {
                        PlayPauseCircle(isPlaying: isPlaying, size: 44)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isPlaying ? "Pausar" : "Reproducir")
                }
            }
            .padding(14)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

#Preview {
    CoursesView(viewModel: CoursesViewModel(service: MockMeditationService()))
}
