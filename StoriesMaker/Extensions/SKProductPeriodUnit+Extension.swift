//
//  SKProductPeriodUnit+Extension.swift
//  StoriesMaker
//
//  Created by borisenko on 21.09.2024.
//

import StoreKit

extension SKProduct.PeriodUnit {
    var textualRepresentation: String {
        switch self {
        case .day:
            return L10n.Subscription.day
        case .week:
            return L10n.Subscription.week
        case .month:
            return L10n.Subscription.month
        case .year:
            return L10n.Subscription.year
        @unknown default:
            return ""
        }
    }
    
    var adverbTextualRepresentation: String {
        switch self {
        case .day:
            return L10n.Subscription.daily
        case .week:
            return L10n.Subscription.weekly
        case .month:
            return L10n.Subscription.monthly
        case .year:
            return L10n.Subscription.yearly
        @unknown default:
            return ""
        }
    }
}
