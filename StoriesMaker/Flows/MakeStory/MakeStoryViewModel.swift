//
//  MakeStoryViewModel.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 08/09/2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol IMakeStoryViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<MakeStory.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<MakeStory.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<MakeStory.Models.ViewRoute, Never> { get }

    func process(input: MakeStory.Models.ViewModelInput)
}

final class MakeStoryViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<MakeStory.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<MakeStory.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<MakeStory.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - IMakeStoryViewModel
extension MakeStoryViewModel: IMakeStoryViewModel {

    var viewStatePublisher: AnyPublisher<MakeStory.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<MakeStory.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<MakeStory.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: MakeStory.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                // handle onLoad here
            }
            .store(in: &self.subscriptions)
        
        input.onMakeStory
            .sink { [weak self] in
                self?.handleMakeStory()
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Private
private extension MakeStoryViewModel {

    func handleMakeStory() {
        let numberOfFreeCreations = SubscriptionHelper.getNumberOfFreeStoriesCreationsLeft()
        
        guard !SubscriptionHelper.isSubscriptionActive() && numberOfFreeCreations <= 0 else {
            self.viewRouteSubject.send(.selectionStepFlow)
            return
        }
        self.viewRouteSubject.send(.subscription)
    }
}
