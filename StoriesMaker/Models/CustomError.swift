//
//  CustomError.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 20/09/2023.
//

import Foundation

enum CustomError: Error {
    
    case loadingSubscriptionProducts(Error?)
    case subscriptionPurchase(Error?)
    case restorePurchases(Error?)
    case openAIRequest(Error?)
    case storyCreation(Error?)
    
    var cTitle: String? {
        switch self {
        case .loadingSubscriptionProducts:
            return L10n.Errors.failedToLoadProducts
        case .subscriptionPurchase:
            return L10n.Errors.failedToBuyProduct
        case .restorePurchases:
            return L10n.Errors.failedToRestorePurchases
        case .openAIRequest:
            return nil
        case .storyCreation:
            return L10n.Errors.failedToCreateStory
        }
    }
    
    var cMessage: String? {
        switch self {
        case .loadingSubscriptionProducts:
            return L10n.Errors.tryAgainOrContactSupport
        case .subscriptionPurchase:
            return L10n.Errors.tryAgainOrContactSupport
        case .restorePurchases:
            return L10n.Errors.tryAgainOrContactSupport
        case .openAIRequest:
            return nil
        case .storyCreation:
            return L10n.Errors.tryAgainOrContactSupport
        }
    }
    
    var cUnderlyingSwiftError: Error? {
        switch self {
        case .loadingSubscriptionProducts(let error),
                .subscriptionPurchase(let error),
                .restorePurchases(let error),
                .openAIRequest(let error),
                .storyCreation(let error):
            return error
        }
    }
}
