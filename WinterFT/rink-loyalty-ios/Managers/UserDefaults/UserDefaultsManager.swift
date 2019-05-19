//
//  UserDefaultsManager.swift
//  rink-loyalty-ios
//
//  Created by Rinat Mukhammetzyanov on 17/03/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

struct UserDefaultsManager {

    // MARK: - Nested Types

    private enum Keys {

        // MARK: - Type Properties

        static let token = "token"
        static let onboarding = "onboardingIsFinished"
    }

    // MARK: - Instance Properties

    static let shared = UserDefaultsManager()

    // MARK: - Instance Methods

    func save(token: String) {
        Log.i(token)

        UserDefaults.standard.set(token, forKey: Keys.token)
    }

    func getToken() -> String? {
        return UserDefaults.standard.value(forKey: Keys.token) as? String
    }

    // MARK: -

    func save(onbordingState: Bool) {
        Log.i(onbordingState)

         UserDefaults.standard.set(onbordingState, forKey: Keys.onboarding)
    }

    func getOnboardingState() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.onboarding)
    }

    // MARK: -

    func clear() {
        guard let domain = Bundle.main.bundleIdentifier else {
            return
        }

        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
