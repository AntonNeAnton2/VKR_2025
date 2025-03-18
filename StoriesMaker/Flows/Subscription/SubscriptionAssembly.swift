//
//  SubscriptionAssembly.swift
//  StoriesMaker
//
//  Created by borisenko on 19.09.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension Subscription {
    
    enum Assembly {}
}

extension Subscription.Assembly {
    
    static func createModule(
        entryPoint: Subscription.Models.EntryPoint,
        isDismissable: Bool
    ) -> UIViewController {
        let viewModel = SubscriptionViewModel(entryPoint: entryPoint)
        let viewController = SubscriptionViewController()
        viewController.setDependencies(viewModel: viewModel, isDismissable: isDismissable)
        return viewController
    }
}
