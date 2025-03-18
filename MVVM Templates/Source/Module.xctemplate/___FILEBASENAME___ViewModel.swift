//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol I___VARIABLE_productName___ViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<___VARIABLE_productName___.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<___VARIABLE_productName___.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<___VARIABLE_productName___.Models.ViewRoute, Never> { get }

    func process(input: ___VARIABLE_productName___.Models.ViewModelInput)
}

final class ___VARIABLE_productName___ViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<___VARIABLE_productName___.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<___VARIABLE_productName___.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<___VARIABLE_productName___.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - I___VARIABLE_productName___ViewModel
extension ___VARIABLE_productName___ViewModel: I___VARIABLE_productName___ViewModel {

    var viewStatePublisher: AnyPublisher<___VARIABLE_productName___.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<___VARIABLE_productName___.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<___VARIABLE_productName___.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: ___VARIABLE_productName___.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                // handle onLoad here
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Private
private extension ___VARIABLE_productName___ViewModel {

}
