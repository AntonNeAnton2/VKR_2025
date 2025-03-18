//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit

extension ___VARIABLE_productName___ {
    
    enum Assembly {}
}

extension ___VARIABLE_productName___.Assembly {
    
    static func createModule() -> UIViewController {
        let viewModel = ___VARIABLE_productName___ViewModel()
        let viewController = ___VARIABLE_productName___ViewController(viewModel: viewModel)
        return viewController
    }
}
