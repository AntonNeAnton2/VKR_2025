//
//  SubscriptionModels.swift
//  StoriesMaker
//
//  Created by borisenko on 19.09.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine
import Glassfy

enum Subscription {}

extension Subscription {
    
    enum Models {}
}

extension Subscription.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onCrossButtonTapped: AnyPublisher<Void, Never>
        let onArrowButtonTapped: AnyPublisher<Void, Never>
        let onOptionSelected: AnyPublisher<String, Never>
        let onRestorePurchasesTapped: AnyPublisher<Void, Never>
        let onTermsOfUseTapped: AnyPublisher<Void, Never>
        let onPrivacyPolicyTapped: AnyPublisher<Void, Never>
        let onSuccessPurchaseDismiss: AnyPublisher<Void, Never>
    }

    // MARK: Output
    enum ViewState {
        case idle
        case loaded(ViewConfig)
    }

    enum ViewAction {
        case showLegal(URL)
        case showError(String?)
        case showPurchaseSuccess
        case showNothingToRestore
        // TODO: Refactor
        case showLoading(Bool)
    }

    enum ViewRoute {
        case closeModule
    }
}

extension Subscription.Models {
    
    enum EntryPoint {
        
        case onboarding
        case makeStory
        case premiumLibrary
        case premiumStory
        case premiumMakeStory
        case premiumSettings
        case firstStory
    }
    
    enum SubscriptionIdentifier: String, CaseIterable {
        case weekly = "ios_magicjourneys_premium_weekly"
        case monthly = "ios_magicjourneys_premium_monthly"
        case yearly = "ios_magicjourneys_premium_yearly"
    }
    
    struct ViewConfig {
        let weekInfo: Glassfy.Sku
        let monthInfo: Glassfy.Sku
        let yearInfo: Glassfy.Sku
    }
}
