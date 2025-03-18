//
//  StoryCreationViewModel.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 19/09/2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol IStoryCreationViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<StoryCreation.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<StoryCreation.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<StoryCreation.Models.ViewRoute, Never> { get }

    func process(input: StoryCreation.Models.ViewModelInput)
}

final class StoryCreationViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<StoryCreation.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<StoryCreation.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<StoryCreation.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let storyCreationService = StoryCreationService()
    
    private let storyConfiguration: StoryConfiguation
    private var progress: Double = 0 {
        didSet {
            self.viewActionSubject.send(.setProgress(self.progress))
        }
    }
    private var lastFacts: [String] = []
    
    init(storyConfiguration: StoryConfiguation) {
        self.storyConfiguration = storyConfiguration
        self.setupSubscriptions()
    }
}

// MARK: - IStoryCreationViewModel
extension StoryCreationViewModel: IStoryCreationViewModel {

    var viewStatePublisher: AnyPublisher<StoryCreation.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<StoryCreation.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<StoryCreation.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: StoryCreation.Models.ViewModelInput) {
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
        
        input.onErrorDismiss
            .sink { [weak self] in
                self?.viewRouteSubject.send(.pop)
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Private
private extension StoryCreationViewModel {
    
    func setupSubscriptions() {
        // TODO: Remove in further versions
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard self?.progress ?? 0 < 1 else { return }
                self?.progress += 0.035
            }
            .store(in: &self.subscriptions)
        
        Timer.publish(every: 7, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.showRandomFact()
            }
            .store(in: &self.subscriptions)
    }
    
    func showRandomFact() {
        guard var fact = Fact.facts.randomElement() else { return }
        while self.lastFacts.contains(fact) {
            guard let random = Fact.facts.randomElement() else { continue }
            fact = random
        }
        self.lastFacts.append(fact)
        if self.lastFacts.count > 5 {
            self.lastFacts.remove(at: 0)
        }
        self.viewActionSubject.send(.setFact(fact))
    }
    
    func onBackButtonTap() {
        self.storyCreationService.cancelStoryCreation()
        self.viewRouteSubject.send(.pop)
    }
    
    func onLoad() {
        AnalyticsManager.shared.track(event: .openStoryCreation)
        self.createStory()
    }

    func createStory() {
        self.storyCreationService.createStory(with: self.storyConfiguration) { [weak self] result in
            switch result {
            case .success(let story):
                self?.viewRouteSubject.send(.story(story))
            case .failure(let error):
                self?.viewActionSubject.send(.showError(error))
            }
        }
    }
}
