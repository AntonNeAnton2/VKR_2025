//
//  SettingsAssembly.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 30/08/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension Settings {
    
    enum Assembly {}
}

extension Settings.Assembly {
    
    static func createModule() -> UIViewController {
        let viewModel = SettingsViewModel()
        let viewController = SettingsViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
