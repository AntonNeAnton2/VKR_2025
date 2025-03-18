//
//  LibraryAssembly.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 08/09/2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension Library {
    
    enum Assembly {}
}

extension Library.Assembly {
    
    static func createModule() -> UIViewController {
        let viewModel = LibraryViewModel()
        let viewController = LibraryViewController()
        viewController.setDependencies(viewModel: viewModel)
        return viewController
    }
}
