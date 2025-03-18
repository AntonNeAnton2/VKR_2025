//
//  UserDefaultsManager.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 29/08/2024.
//

import Foundation

final class UserDefaultsManager {
    
    enum UserDefaultsKey: String {
        
        case firstLaunchPerformed
        case onboardingWasShown
        case numberOfFreeCreations
        case isSubscriptionActive
        case firstStoryCreated
        case firstStoryPaywallShown
    }
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func save(value: Any, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getBool(by key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    func get(by key: UserDefaultsKey) -> Any? {
        UserDefaults.standard.value(forKey: key.rawValue)
    }
}
