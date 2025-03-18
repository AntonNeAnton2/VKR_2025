//
//  LibraryAssembly.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 08/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
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
