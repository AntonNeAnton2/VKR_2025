//
//  LibraryViewModel.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 08/09/2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol ILibraryViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<Library.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<Library.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<Library.Models.ViewRoute, Never> { get }

    func process(input: Library.Models.ViewModelInput)
}

final class LibraryViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<Library.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<Library.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<Library.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - ILibraryViewModel
extension LibraryViewModel: ILibraryViewModel {

    var viewStatePublisher: AnyPublisher<Library.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<Library.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<Library.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: Library.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                // handle onLoad here
            }
            .store(in: &self.subscriptions)

        input.onViewWillAppear
            .sink { [weak self] in
                self?.refetch()
            }
            .store(in: &subscriptions)

        input.onMakeStory
            .sink { [weak self] in
                self?.handleMakeStory()
            }
            .store(in: &self.subscriptions)

        input.onDeleteMyStory
            .sink { [weak self] myStory in
                self?.deleteMyStory(myStory)
            }
            .store(in: &subscriptions)
        
        input.onSelectMyStory
            .sink { [weak self] myStory in
                self?.viewRouteSubject.send(.story(myStory))
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Private
private extension LibraryViewModel {
    
    func refetch(updateUIOnlyIfEmpty: Bool = false) {
        let myStories: [MyStory] = MyStoriesRepository.shared.getMyStories()
        guard myStories.isEmpty == false else {
            self.viewActionSubject.send(.showEmptyState(true))
            return
        }
        if updateUIOnlyIfEmpty == false {
            self.viewActionSubject.send(.showEmptyState(false))
            self.viewActionSubject.send(.showMyStories(myStories))
        }
    }

    func deleteMyStory(_ myStory: MyStory) {
        MyStoriesRepository.shared.delete(myStory: myStory)
        self.refetch(updateUIOnlyIfEmpty: true)
    }
    
    func handleMakeStory() {
        let numberOfFreeCreations = SubscriptionHelper.getNumberOfFreeStoriesCreationsLeft()
        
        guard !SubscriptionHelper.isSubscriptionActive() && numberOfFreeCreations <= 0 else {
            self.viewRouteSubject.send(.selectionStepFlow)
            return
        }
        self.viewRouteSubject.send(.subscription)
    }
}
