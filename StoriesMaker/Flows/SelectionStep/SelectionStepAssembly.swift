//
//  SelectionStepAssembly.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 09/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension SelectionStep {
    
    enum Assembly {}
}

extension SelectionStep.Assembly {
    
    static func createModule(config: SelectionStep.Models.Configuration) -> UIViewController {
        let viewModel = SelectionStepViewModel(config: config)
        let viewController = SelectionStepViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
