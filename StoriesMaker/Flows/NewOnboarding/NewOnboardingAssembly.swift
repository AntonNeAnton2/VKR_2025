//
//  NewOnboardingAssembly.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 6.12.24.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension NewOnboarding {
    
    enum Assembly {}
}

extension NewOnboarding.Assembly {
    
    static func createModule() -> UIViewController {
        let viewModel = NewOnboardingViewModel()
        let viewController = NewOnboardingViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
