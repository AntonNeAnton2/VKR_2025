//
//  SKProduct+Extension.swift
//  StoriesMaker
//
//  Created by borisenko on 22.09.2024.
//

import StoreKit

extension SKProduct {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var localizedPrice: String? {
        let formatter = SKProduct.formatter
        formatter.locale = priceLocale

        return formatter.string(from: price)
    }

}
