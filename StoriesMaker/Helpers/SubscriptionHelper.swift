//
//  SubscriptionHelper.swift
//  StoriesMaker
//
//  Created by borisenko on 22.09.2023.
//

import Glassfy

struct SubscriptionHelper {
    
    private static let defaultNumberOfFreeStoriesCreations = 2
    
    static func getNumberOfFreeStoriesCreationsLeft() -> Int {
        guard let numberOfFreeCreations = UserDefaultsManager.shared.get(by: .numberOfFreeCreations) as? Int else {
            setNumberOfFreeCreationsLeft(defaultNumberOfFreeStoriesCreations)
            return defaultNumberOfFreeStoriesCreations
        }
        
        return numberOfFreeCreations
    }
    
    static func reduceNumberOfFreeStoriesCreationsLeft() {
        let numberOfFreeCreations = getNumberOfFreeStoriesCreationsLeft()
        setNumberOfFreeCreationsLeft(numberOfFreeCreations - 1)
    }
    
    static func isSubscriptionActive() -> Bool {
        UserDefaultsManager.shared.getBool(by: .isSubscriptionActive)
    }
    
    static func setSubscription(isActive: Bool) {
        UserDefaultsManager.shared.save(value: isActive, forKey: .isSubscriptionActive)
    }
    
    static func updateSubscriptionInfo(completion: ((Bool?) -> ())?) {
        Glassfy.permissions { permission, error in
            guard error == nil else {
                completion?(nil)
                return
            }
            
            guard permission?.all.first(where: { $0.permissionId == "premiumAccess" })?.isValid ?? false else {
                setSubscription(isActive: false)
                completion?(false)
                return
            }
            
            setSubscription(isActive: true)
            completion?(true)
        }
    }
}

// MARK: - Private
private extension SubscriptionHelper {
    
    static func setNumberOfFreeCreationsLeft(_ value: Int) {
        UserDefaultsManager.shared.save(
            value: value,
            forKey: .numberOfFreeCreations
        )
    }
}
