//
//  StoryViewModel.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 20.09.23.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol IStoryViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<Story.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<Story.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<Story.Models.ViewRoute, Never> { get }

    func process(input: Story.Models.ViewModelInput)
}

final class StoryViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<Story.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<Story.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<Story.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    private let config: Story.Models.Configuration

    init(config: Story.Models.Configuration) {
        self.config = config
    }
}

// MARK: - IStoryViewModel
extension StoryViewModel: IStoryViewModel {

    var viewStatePublisher: AnyPublisher<Story.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<Story.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<Story.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: Story.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                self?.onLoad()
            }
            .store(in: &self.subscriptions)

        input.onBackButtonTap
            .sink { [weak self] in
                self?.onBackButtonTap()
            }
            .store(in: &self.subscriptions)
        
        input.onSaveButtonTap
            .sink { [weak self] in
                self?.onSaveButtonTap()
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Private
private extension StoryViewModel {

    func onLoad() {
        let entryPoint: AnalyticsManager.Model.StoryEntryPoint = {
            switch self.config.entryPoint {
            case .storyCreation:
                return .storyCreation
            case .library:
                return .library
            }
        }()
        
        AnalyticsManager.shared.track(
            event: .openStory,
            parameters: [AnalyticsManager.Key.entryPoint: entryPoint.value]
        )
        
        if !SubscriptionHelper.isSubscriptionActive() && self.config.entryPoint == .storyCreation {
            SubscriptionHelper.reduceNumberOfFreeStoriesCreationsLeft()
        }
        
        if entryPoint == .storyCreation, !UserDefaultsManager.shared.getBool(by: .firstStoryCreated) {
            UserDefaultsManager.shared.save(value: true, forKey: .firstStoryCreated)
        }
        
        self.viewStateSubject.send(.loaded(self.config))
    }

    func onBackButtonTap() {
        switch self.config.backButtonState {
        case .pop:
            self.viewRouteSubject.send(.pop)
        case .dismiss:
            self.viewRouteSubject.send(.dismiss)
        }
    }

    func onSaveButtonTap() {
        let myStories = MyStoriesRepository.shared.getMyStories()
        
        if myStories.contains(self.config.story) {
            self.viewActionSubject.send(.saveButtonState(.inactive))
            MyStoriesRepository.shared.delete(myStory: self.config.story)
        } else {
            self.viewActionSubject.send(.saveButtonState(.active))
            MyStoriesRepository.shared.save(myStory: self.config.story)
        }
    }
}
