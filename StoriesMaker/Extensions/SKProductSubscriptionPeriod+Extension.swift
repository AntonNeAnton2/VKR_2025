//
//  SKProductSubscriptionPeriod+Extension.swift
//  StoriesMaker
//
//  Created by borisenko on 21.09.2024.
//

import StoreKit

extension SKProductSubscriptionPeriod {
    var normalizedPeriodUnit: SKProduct.PeriodUnit {
        switch self.unit {
        case .day where self.numberOfUnits == 7:
            return .week
        default:
            return self.unit
        }
    }
}
