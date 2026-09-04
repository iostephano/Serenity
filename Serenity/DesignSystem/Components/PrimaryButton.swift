//
//  PrimaryButton.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .frame(minWidth: 160)
            .frame(height: 95)
            .background(DSColor.primary)
            .clipShape(RoundedRectangle(cornerRadius: 45, style: .continuous))
            .overlay(
                LinearGradient(
                    colors: [Color.white.opacity(0.18), .clear],
                    startPoint: .topLeading, endPoint: .center
                )
                .clipShape(RoundedRectangle(cornerRadius: 45, style: .continuous))
            )
            .shadow(color: DSColor.primary.opacity(0.28), radius: 22, x: 0, y: 10)
        }
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(.isButton)
    }
}
