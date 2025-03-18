//
//  SelectionStepModels.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 09/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine
import UIKit

enum SelectionStep {}

extension SelectionStep {
    
    enum Models {}
}

extension SelectionStep.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onBackButtonTap: AnyPublisher<Void, Never>
        let onNextButtonTap: AnyPublisher<Void, Never>
        let onCellTap: AnyPublisher<Int, Never>
        let onSelectRandomTap: AnyPublisher<Void, Never>
        let onAddCharacter: AnyPublisher<Void, Never>
        let onSaveCustomCharacter: AnyPublisher<CustomCharacter, Never>
        let onRemoveCustomCharacter: AnyPublisher<CustomCharacter, Never>
    }

    // MARK: Output
    enum ViewState: Equatable {
        case idle
        case loaded(Configuration)
    }

    enum ViewAction {
        case enableNextButton(Bool)
        case showAddCharacterDialog
    }

    enum ViewRoute {
        case dismiss
        case pop
        case selectionStep(config: Configuration)
        case storyCreation(config: StoryConfiguation)
    }
}

extension SelectionStep.Models {
    
    enum Step {
        
        case universe
        case characters
        case events
        case moral
        
        var next: Step? {
            switch self {
            case .universe:
                return .characters
            case .characters:
                return .events
            case .events:
                return .moral
            case .moral:
                return nil
            }
        }
        
        var hasPrevious: Bool {
            switch self {
            case .universe:
                return false
            default:
                return true
            }
        }
        
        var title: String {
            switch self {
            case .universe:
                return L10n.SelectionStep.Title.universe
            case .characters:
                return L10n.SelectionStep.Title.characters
            case .events:
                return L10n.SelectionStep.Title.events
            case .moral:
                return L10n.SelectionStep.Title.moral
            }
        }
        
        var info: String {
            switch self {
            case .universe:
                return L10n.SelectionStep.Info.universe
            case .characters:
                return L10n.SelectionStep.Info.characters
            case .events:
                return L10n.SelectionStep.Info.events
            case .moral:
                return L10n.SelectionStep.Info.moral
            }
        }
        
        var progressImage: UIImage {
            switch self {
            case .universe:
                return Asset.Images.progress1.image
            case .characters:
                return Asset.Images.progress2.image
            case .events:
                return Asset.Images.progress3.image
            case .moral:
                return Asset.Images.progress4.image
            }
        }
        
        var selectRandomText: String {
            switch self {
            case .universe:
                return L10n.SelectionStep.RandomText.universe
            case .characters:
                return L10n.SelectionStep.RandomText.characters
            case .events:
                return L10n.SelectionStep.RandomText.events
            case .moral:
                return L10n.SelectionStep.RandomText.moral
            }
        }
        
        enum SelectionType {
            case single
            case multiple
        }
        
        var selectionType: SelectionType {
            switch self {
            case .universe:
                return .single
            case .characters:
                return .multiple
            case .events:
                return .multiple
            case .moral:
                return .single
            }
        }
    }
    
    final class Configuration: Equatable {
        
        let storyConfig: StoryConfiguation?
        let step: Step
        var customCharacters: [CustomCharacter] {
            didSet {
                self.onCustomCharactersChange?()
            }
        }
        let cellDataModels: [SelectionStepCellDataModel]
        
        var onCustomCharactersChange: (() -> Void)?
        
        init(
            storyConfig: StoryConfiguation?,
            step: Step,
            customCharacters: [CustomCharacter] = [CustomCharacter](),
            cellDataModels: [SelectionStepCellDataModel]
        ) {
            self.storyConfig = storyConfig
            self.step = step
            self.customCharacters = customCharacters
            self.cellDataModels = cellDataModels
        }
        
        static var initial: Configuration {
            .init(
                storyConfig: .init(),
                step: .universe,
                cellDataModels: Universe.allCases.map { .init(dataSource: $0) }
            )
        }
        
        static func == (
            lhs: SelectionStep.Models.Configuration,
            rhs: SelectionStep.Models.Configuration
        ) -> Bool {
            lhs.step == rhs.step
        }
    }
}

