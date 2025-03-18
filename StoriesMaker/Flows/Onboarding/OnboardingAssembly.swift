//
//  OnboardingAssembly.swift
//  StoriesMaker
//
//  Created by borisenko on 11.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension Onboarding {
    
    enum Assembly {}
}

extension Onboarding.Assembly {
    
    static func createModule(onStartUsing: @escaping () -> Void) -> UIViewController {
        let viewModel = OnboardingViewModel(onStartUsing: onStartUsing)
        let viewController = OnboardingViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
