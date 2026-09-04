//
//  SerenityApp.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import SwiftUI

@main
struct SerenityApp: App {
    @State private var router = AppRouter()
    private let service: MeditationServiceProtocol = MockMeditationService()

    var body: some Scene {
        WindowGroup {
            switch router.screen {
            case .onboarding:
                OnboardingView(router: router)
            case .courses:
                CoursesView(viewModel: CoursesViewModel(service: service))
            }
        }
    }
}
