//
//  SelectionStepViewModel.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 09/09/2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

protocol ISelectionStepViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<SelectionStep.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<SelectionStep.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<SelectionStep.Models.ViewRoute, Never> { get }

    func process(input: SelectionStep.Models.ViewModelInput)
}

final class SelectionStepViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<SelectionStep.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<SelectionStep.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<SelectionStep.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    private let config: SelectionStep.Models.Configuration
    
    init(config: SelectionStep.Models.Configuration) {
        self.config = config
    }
}

// MARK: - ISelectionStepViewModel
extension SelectionStepViewModel: ISelectionStepViewModel {

    var viewStatePublisher: AnyPublisher<SelectionStep.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<SelectionStep.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<SelectionStep.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: SelectionStep.Models.ViewModelInput) {
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
        
        input.onNextButtonTap
            .sink { [weak self] in
                self?.onNextButtonTap()
            }
            .store(in: &self.subscriptions)
        
        input.onCellTap
            .sink { [weak self] index in
                self?.onCellTap(index: index)
            }
            .store(in: &self.subscriptions)
        
        input.onSelectRandomTap
            .sink { [weak self] in
                self?.selectRandom()
            }
            .store(in: &self.subscriptions)
        
        input.onAddCharacter
            .sink { [weak self] in
                self?.onAddCharacter()
            }
            .store(in: &self.subscriptions)
        
        input.onSaveCustomCharacter
            .sink { [weak self] character in
                self?.onSaveCustomCharacter(character)
            }
            .store(in: &self.subscriptions)
        
        input.onRemoveCustomCharacter
            .sink { [weak self] character in
                self?.onRemoveCustomCharacter(character)
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Private
private extension SelectionStepViewModel {
    
    func onLoad() {
        self.viewStateSubject.send(.loaded(self.config))
        
        switch self.config.step {
        case .universe:
            AnalyticsManager.shared.track(event: .openSelectUniverse)
        case .characters:
            AnalyticsManager.shared.track(event: .openSelectCharacters)
        case .events:
            AnalyticsManager.shared.track(event: .openSelectEvents)
        case .moral:
            AnalyticsManager.shared.track(event: .openSelectMoral)
        }
    }
    
    func onBackButtonTap() {
        if self.config.step.hasPrevious {
            self.viewRouteSubject.send(.pop)
        } else {
            self.viewRouteSubject.send(.dismiss)
        }
    }

    func onNextButtonTap() {
        if let next = self.config.step.next {
            self.proceedToSelectionStep(next)
        } else {
            self.viewRouteSubject.send(.storyCreation(config: self.makeStoryConfig()))
        }
    }
    
    func proceedToSelectionStep(_ step: SelectionStep.Models.Step) {
        let storyConfig = self.makeStoryConfig()
        guard let universe = storyConfig.universe,
              let cellDataModels = universe.makeCellDataModels(for: step) else { return }
        let config: SelectionStep.Models.Configuration = .init(
            storyConfig: storyConfig,
            step: step,
            cellDataModels: cellDataModels
        )
        self.viewRouteSubject.send(.selectionStep(config: config))
    }
    
    func makeStoryConfig() -> StoryConfiguation {
        let currentStoryConfig = self.config.storyConfig
        let selectedItems = self.config.cellDataModels.filter { $0.isSelected }
        switch self.config.step {
        case .universe:
            var universe: Universe?
            for item in selectedItems {
                if let uni = Universe(rawValue: item.dataSource.id) {
                    universe = uni
                }
            }
            return .init(universe: universe)
        case .characters:
            var characters = [Character]()
            for item in selectedItems {
                if let character = Character(rawValue: item.dataSource.id) {
                    characters.append(character)
                }
            }
            return .init(
                universe: currentStoryConfig?.universe,
                characters: characters,
                customCharacters: self.config.customCharacters
            )
        case .events:
            var events = [Event]()
            for item in selectedItems {
                if let event = Event(rawValue: item.dataSource.id) {
                    events.append(event)
                }
            }
            return .init(
                universe: currentStoryConfig?.universe,
                characters: currentStoryConfig?.characters,
                customCharacters: currentStoryConfig?.customCharacters,
                events: events
            )
        case .moral:
            var moral: Moral?
            for item in selectedItems {
                if let mor = Moral(rawValue: item.dataSource.id) {
                    moral = mor
                }
            }
            return .init(
                universe: currentStoryConfig?.universe,
                characters: currentStoryConfig?.characters,
                customCharacters: currentStoryConfig?.customCharacters,
                events: currentStoryConfig?.events,
                moral: moral
            )
        }
    }
    
    func onCellTap(index: Int) {
        if self.config.step.selectionType == .single && !self.config.cellDataModels[index].isSelected {
            self.config.cellDataModels.filter { $0.isSelected }.forEach { $0.toggleSelection() }
        }
        self.config.cellDataModels[index].toggleSelection()
        self.refreshNextStepAvailability()
    }
    
    func refreshNextStepAvailability() {
        let enableNextButton = self.config.cellDataModels.contains { $0.isSelected } || (self.config.step == .characters && !self.config.customCharacters.isEmpty)
        self.viewActionSubject.send(.enableNextButton(enableNextButton))
    }
    
    func selectRandom() {
        var prevSelectedIndex: Int?
        if self.config.cellDataModels.filter({ $0.isSelected }).count == 1 {
            prevSelectedIndex = self.config.cellDataModels.firstIndex(where: { $0.isSelected })
        }
        self.config.cellDataModels.filter { $0.isSelected }.forEach { $0.toggleSelection() }
        var indiciesToSelect = Set<Int>()
        let itemsToSelectCount: Int
        switch self.config.step.selectionType {
        case .single:
            itemsToSelectCount = 1
        case .multiple:
            itemsToSelectCount = 3
        }
        
        while indiciesToSelect.count < itemsToSelectCount {
            var shouldCreateANewOne = true
            var index: Int = 0
            while shouldCreateANewOne {
                index = Int.random(in: 0...self.config.cellDataModels.count - 1)
                if itemsToSelectCount == 1, let prevSelectedIndex = prevSelectedIndex {
                    shouldCreateANewOne = index == prevSelectedIndex
                } else {
                    shouldCreateANewOne = false
                }
            }
            indiciesToSelect.insert(index)
        }
    
        indiciesToSelect.forEach {
            self.config.cellDataModels[$0].toggleSelection()
            self.refreshNextStepAvailability()
        }
    }
    
    func onAddCharacter() {
        self.viewActionSubject.send(.showAddCharacterDialog)
    }
    
    func onSaveCustomCharacter(_ customCharacter: CustomCharacter) {
        self.config.customCharacters.append(customCharacter)
        self.refreshNextStepAvailability()
    }
    
    func onRemoveCustomCharacter(_ customCharacter: CustomCharacter) {
        guard let index = self.config.customCharacters.firstIndex(of: customCharacter) else { return }
        self.config.customCharacters.remove(at: index)
        self.refreshNextStepAvailability()
    }
}
