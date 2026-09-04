//
//  OnboardingView.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

struct OnboardingView: View {
    let router: AppRouter

    private let sidePadding: CGFloat = 24
    private let logoSize: CGFloat = 88
    private let logoTopSpace: CGFloat = 320
    private let titleFontSize: CGFloat = 56
    private let titleWidth: CGFloat = 340

    var body: some View {
        ZStack(alignment: .topLeading) {
            GradientBackground(style: .onboarding)

            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: logoTopSpace)

                LotusMark(lineWidth: 2)
                    .frame(width: logoSize, height: logoSize)
                    .opacity(0.9)

                Text("Todas tus\nmeditaciones\nen una sola app")
                    .font(.system(size: titleFontSize, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineSpacing(6)
                    .frame(width: titleWidth, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 24)

                Spacer()

                HStack(spacing: 16) {
                    Spacer(minLength: 0)
                    SecondaryButton(title: "Explorar") { }
                    PrimaryButton(title: "Empezar", icon: "arrow.up.right") {
                        withAnimation { router.screen = .courses }
                    }
                    Spacer(minLength: 0)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, sidePadding)
            .padding(.top, 12)
        }
    }
}

#Preview {
    OnboardingView(router: AppRouter())
}
