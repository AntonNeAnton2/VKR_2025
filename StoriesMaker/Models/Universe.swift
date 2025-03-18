//
//  Universe.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 09/09/2023.
//

import UIKit

enum Universe: Int, CaseIterable {
    
    case piratesParadise
    case dinoIsland
    case candyLand
    case animalFarm
    case wizardSchool
    case princessCastle
    case mistwood
    
    var image: UIImage {
        switch self {
        case .piratesParadise:
            return Asset.Images.unPiratesParadise.image
        case .dinoIsland:
            return Asset.Images.unDinoIsland.image
        case .candyLand:
            return Asset.Images.unCandyLand.image
        case .animalFarm:
            return Asset.Images.unAnimalFarm.image
        case .wizardSchool:
            return Asset.Images.unWizardSchool.image
        case .princessCastle:
            return Asset.Images.unPrincessCastle.image
        case .mistwood:
            return Asset.Images.unMistwood.image
        }
    }
    
    var name: String {
        switch self {
        case .piratesParadise:
            return L10n.Universe.Name.piratesParadise
        case .dinoIsland:
            return L10n.Universe.Name.dinoIsland
        case .candyLand:
            return L10n.Universe.Name.candyLand
        case .animalFarm:
            return L10n.Universe.Name.animalFarm
        case .wizardSchool:
            return L10n.Universe.Name.wizardSchool
        case .princessCastle:
            return L10n.Universe.Name.princessCastle
        case .mistwood:
            return L10n.Universe.Name.mistwood
        }
    }
    
    var descriptionForPrompt: String {
        switch self {
        case .piratesParadise:
            return L10n.Universe.Prompt.Description.piratesParadise
        case .dinoIsland:
            return L10n.Universe.Prompt.Description.dinoIsland
        case .candyLand:
            return L10n.Universe.Prompt.Description.candyLand
        case .animalFarm:
            return L10n.Universe.Prompt.Description.animalFarm
        case .wizardSchool:
            return L10n.Universe.Prompt.Description.wizardSchool
        case .princessCastle:
            return L10n.Universe.Prompt.Description.princessCastle
        case .mistwood:
            return L10n.Universe.Prompt.Description.mistwood
        }
    }
    
    var characters: [Character] {
        switch self {
        case .piratesParadise:
            return Character.piratesParadiseCharacters
        case .dinoIsland:
            return Character.dinoIslandCharacters
        case .candyLand:
            return Character.candyLandCharacters
        case .animalFarm:
            return Character.animalFarmCharacters
        case .wizardSchool:
            return Character.wizardSchoolCharacters
        case .princessCastle:
            return Character.princessCastleCharacters
        case .mistwood:
            return Character.mistwoodCharacters
        }
    }
    
    var events: [Event] {
        switch self {
        case .piratesParadise:
            return Event.piratesParadiseEvents
        case .dinoIsland:
            return Event.dinoIslandEvents
        case .candyLand:
            return Event.candyLandEvents
        case .animalFarm:
            return Event.animalFarmEvents
        case .wizardSchool:
            return Event.wizardSchoolEvents
        case .princessCastle:
            return Event.princessCastleEvents
        case .mistwood:
            return Event.mistwoodEvents
        }
    }
    
    var backgroundMusic: MusicManager.MusicFile {
        switch self {
        case .piratesParadise:
            return .defaultStoryBackground
        case .dinoIsland:
            return .defaultStoryBackground
        case .candyLand:
            return .defaultStoryBackground
        case .animalFarm:
            return .defaultStoryBackground
        case .wizardSchool:
            return .defaultStoryBackground
        case .princessCastle:
            return .defaultStoryBackground
        case .mistwood:
            return .defaultStoryBackground
        }
    }
    
    func makeCellDataModels(for step: SelectionStep.Models.Step) -> [SelectionStepCellDataModel]? {
        switch step {
        case .universe:
            return nil
        case .characters:
            return self.characters.map { .init(dataSource: $0) }
        case .events:
            return self.events.map { .init(dataSource: $0) }
        case .moral:
            return Moral.allCases.map { .init(dataSource: $0) }
        }
    }
}

// MARK: - SelectionStepCellDataSource
extension Universe: SelectionStepCellDataSource {
    
    var id: Int {
        self.rawValue
    }
    
    var selectionStepCellImage: UIImage {
        self.image
    }
    
    var selectionStepCellText: String? {
        self.name
    }
    
    var shouldShowFrame: Bool {
        false
    }
    
    var imageScaleMultiplier: CGFloat {
        1
    }
}
