//
//  StoryAssembly.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 20.09.23.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension Story {
    
    enum Assembly {}
}

extension Story.Assembly {
    
    static func createModule(config: Story.Models.Configuration) -> UIViewController {
        let viewModel = StoryViewModel(config: config)
        let viewController = StoryViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
