//
//  NewOnboardingViewModel.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 6.12.24.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol INewOnboardingViewModel: AnyObject {
    
    var steps: [NewOnboarding.Models.Step] { get }
    
    var viewStatePublisher: AnyPublisher<NewOnboarding.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<NewOnboarding.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<NewOnboarding.Models.ViewRoute, Never> { get }

    func process(input: NewOnboarding.Models.ViewModelInput)
}

final class NewOnboardingViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<NewOnboarding.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<NewOnboarding.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<NewOnboarding.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - INewOnboardingViewModel
extension NewOnboardingViewModel: INewOnboardingViewModel {
    
    var steps: [NewOnboarding.Models.Step] {
        [.welcome, .experienceTheWonder, .saveStories]
    }

    var viewStatePublisher: AnyPublisher<NewOnboarding.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<NewOnboarding.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<NewOnboarding.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: NewOnboarding.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                // handle onLoad here
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Private
private extension NewOnboardingViewModel {

}
