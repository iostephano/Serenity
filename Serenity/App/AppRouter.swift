//
//  AppRouter.swift
//  Serenity
//
//  Created by Stephano Portella on 12/08/25.
//

import Observation

@Observable
final class AppRouter {
    enum Screen {
        case onboarding
        case courses
    }

    var screen: Screen = .onboarding
}
