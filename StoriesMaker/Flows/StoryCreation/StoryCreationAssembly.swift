//
//  StoryCreationAssembly.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 19/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension StoryCreation {
    
    enum Assembly {}
}

extension StoryCreation.Assembly {
    
    static func createModule(storyConfiguration: StoryConfiguation) -> UIViewController {
        let viewModel = StoryCreationViewModel(storyConfiguration: storyConfiguration)
        let viewController = StoryCreationViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
