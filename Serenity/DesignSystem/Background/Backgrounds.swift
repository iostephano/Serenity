//
//  Backgrounds.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

enum BackgroundStyle {
    case onboarding
    case courses
}

struct GradientBackground: View {
    var style: BackgroundStyle = .onboarding

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0C0E0D"), Color(hex: "#101812")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )

            switch style {
            case .onboarding:
                onboardingLayers
            case .courses:
                coursesLayers
            }

            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [.clear, Color.black.opacity(0.38)],
                        center: .center, startRadius: 50, endRadius: 540
                    )
                )
                .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }

    // MARK: - Layers por estilo

    private var onboardingLayers: some View {
        ZStack {
            // Glow superior derecho (cae fuera del encuadre)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#C6FF4D").opacity(0.95), .clear],
                        center: .topTrailing, startRadius: 18, endRadius: 370
                    )
                )
                .offset(x: 165, y: -155)
                .blur(radius: 85)
                .blendMode(.screen)

            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#B8F45E").opacity(0.26), .clear],
                        startPoint: .topTrailing, endPoint: .center
                    )
                )
                .rotationEffect(.degrees(10))
                .offset(x: 56, y: -6)
                .blur(radius: 70)
                .blendMode(.screen)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#79E43F").opacity(0.52), .clear],
                        center: .bottomLeading, startRadius: 0, endRadius: 310
                    )
                )
                .offset(x: -138, y: 210)
                .blur(radius: 60)
                .blendMode(.screen)
        }
    }
    
    private var coursesLayers: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#C6FF4D").opacity(0.75), .clear],
                        center: .init(x: 0.82, y: 0.05), startRadius: 10, endRadius: 320
                    )
                )
                .blur(radius: 70)
                .blendMode(.screen)

            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.08), .clear],
                        startPoint: .top, endPoint: .center
                    )
                )
                .offset(y: -40)
                .blur(radius: 90)
                .blendMode(.screen)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#79E43F").opacity(0.28), .clear],
                        center: .bottomLeading, startRadius: 0, endRadius: 300
                    )
                )
                .offset(x: -120, y: 260)
                .blur(radius: 70)
                .blendMode(.screen)
        }
    }
}



