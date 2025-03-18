//
//  OnboardingViewModel.swift
//  StoriesMaker
//
//  Created by borisenko on 11.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol IOnboardingViewModel: AnyObject {
    
    var steps: [Onboarding.Models.Step] { get }
    
    var viewStatePublisher: AnyPublisher<Onboarding.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<Onboarding.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<Onboarding.Models.ViewRoute, Never> { get }

    func process(input: Onboarding.Models.ViewModelInput)
}

final class OnboardingViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<Onboarding.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<Onboarding.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<Onboarding.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let onStartUsing: () -> Void
    
    private let numberOfIndicies = Onboarding.Models.Step.allCases.count
    
    private var trackedIndices = [Int]()
    
    init(onStartUsing: @escaping () -> Void) {
        self.onStartUsing = onStartUsing
    }
}

// MARK: - IOnboardingViewModel
extension OnboardingViewModel: IOnboardingViewModel {
    
    var steps: [Onboarding.Models.Step] {
        [.welcome, .experienceTheWonder, .saveStories]
    }

    var viewStatePublisher: AnyPublisher<Onboarding.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<Onboarding.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<Onboarding.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: Onboarding.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                // handle onLoad here
            }
            .store(in: &self.subscriptions)
        
        input.onUpdateCurrentIndex
            .sink { [weak self] index in
                self?.onUpdateCurrentIndex(index)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Private
private extension OnboardingViewModel {
    func onUpdateCurrentIndex(_ index: Int) {
        if !self.trackedIndices.contains(index) {
            switch index {
            case 0:
                AnalyticsManager.shared.track(event: .onboardingPage1)
            case 1:
                AnalyticsManager.shared.track(event: .onboardingPage2)
            case 2:
                AnalyticsManager.shared.track(event: .onboardingPage3)
            case 3:
                AnalyticsManager.shared.track(event: .closeOnboarding)
            default:
                break
            }
            self.trackedIndices.append(index)
        }
        
        guard index == self.numberOfIndicies else { return }
        
        self.onStartUsing()
    }
}
