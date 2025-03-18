//
//  MakeStoryAssembly.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 08/09/2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension MakeStory {
    
    enum Assembly {}
}

extension MakeStory.Assembly {
    
    static func createModule() -> UIViewController {
        let viewModel = MakeStoryViewModel()
        let viewController = MakeStoryViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
