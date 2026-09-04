//
//  TagChip.swift
//  Serenity
//
//  Created by Stephano Portella on 13/08/25.
//

import SwiftUI

enum TagChipStyle { case dark, light }

struct TagChip: View {
    var title: String
    var style: TagChipStyle = .dark

    init(_ title: String, style: TagChipStyle = .dark) {
        self.title = title
        self.style = style
    }

    var body: some View {
        Text(title)
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(style == .dark ? .white.opacity(0.08) : .white.opacity(0.9))
            )
            .overlay(
                Capsule().stroke(.white.opacity(style == .dark ? 0.12 : 0.2), lineWidth: 1)
            )
            .foregroundColor(style == .dark ? .white.opacity(0.9) : .black)
    }
}
