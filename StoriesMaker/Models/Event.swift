//
//  Event.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 09/09/2024.
//

import UIKit

enum Event: Int {
    
    // MARK: Pirates' Paradise
    case shipwreck
    case dessertIsland
    case treasureChest
    case seaBattle
    case portRaid
    
    // MARK: Dino Island
    case iceAge
    case neanderthals
    case volcano
    case timeTravel
    case newFruits
    
    // MARK: Candy Land
    case saveMeltCity
    case buildGingerHouse
    case chocolateRiver
    case sweetSodaRain
    case warWithSourKingdom
    
    // MARK: Animal Farm
    case wolfPackAttack
    case assistTheFarmer
    case rescueTheHarvest
    case tractorRepair
    case piggysBirthday
    
    // MARK: Wizard School
    case broomstickFlight
    case potionBrewing
    case learningSpells
    case duelDarkWizard
    case visitHauntedHouse
    
    // MARK: Princess Castle
    case highTower
    case magicalForest
    case woodlandCreatures
    case ball
    case meetFairy
    
    // MARK: Mistwood
    case greatBattle
    case captureByTrolls
    case elvenRelics
    case goblinDungeon
    case darkForest
    
    static var piratesParadiseEvents: [Event] {
        [
            .shipwreck,
            .dessertIsland,
            .treasureChest,
            .seaBattle,
            .portRaid
        ]
    }
    
    static var dinoIslandEvents: [Event] {
        [
            .iceAge,
            .neanderthals,
            .volcano,
            .timeTravel,
            .newFruits
        ]
    }
    static var candyLandEvents: [Event] {
        [
            .saveMeltCity,
            .buildGingerHouse,
            .chocolateRiver,
            .sweetSodaRain,
            .warWithSourKingdom
        ]
    }
    
    static var animalFarmEvents: [Event] {
        [
            .wolfPackAttack,
            .assistTheFarmer,
            .rescueTheHarvest,
            .tractorRepair,
            .piggysBirthday
        ]
    }
    
    static var wizardSchoolEvents: [Event] {
        [
            .broomstickFlight,
            .potionBrewing,
            .learningSpells,
            .duelDarkWizard,
            .visitHauntedHouse
        ]
    }
    
    static var princessCastleEvents: [Event] {
        [
            .highTower,
            .magicalForest,
            .woodlandCreatures,
            .ball,
            .meetFairy
        ]
    }
    
    static var mistwoodEvents: [Event] {
        [
            .greatBattle,
            .captureByTrolls,
            .elvenRelics,
            .goblinDungeon,
            .darkForest
        ]
    }
    
    var image: UIImage {
        switch self {
        case .shipwreck:
            return Asset.Images.evShipwreck.image
        case .dessertIsland:
            return Asset.Images.evDessertIsl.image
        case .treasureChest:
            return Asset.Images.evTreasureChest.image
        case .seaBattle:
            return Asset.Images.evSeaBattle.image
        case .portRaid:
            return Asset.Images.evPortRaid.image
        case .iceAge:
            return Asset.Images.evIceAge.image
        case .neanderthals:
            return Asset.Images.evNeanderthals.image
        case .volcano:
            return Asset.Images.evVolcano.image
        case .timeTravel:
            return Asset.Images.evTimeTravel.image
        case .newFruits:
            return Asset.Images.evNewFruits.image
        case .saveMeltCity:
            return Asset.Images.evSaveMeltCity.image
        case .buildGingerHouse:
            return Asset.Images.evBuilGinHouse.image
        case .chocolateRiver:
            return Asset.Images.evChocRiver.image
        case .sweetSodaRain:
            return Asset.Images.evSwSodeRain.image
        case .warWithSourKingdom:
            return Asset.Images.evWarWithSoKing.image
        case .wolfPackAttack:
            return Asset.Images.evWolfPackAttack.image
        case .assistTheFarmer:
            return Asset.Images.evAssisTheFarmer.image
        case .rescueTheHarvest:
            return Asset.Images.evRescueTheHarvest.image
        case .tractorRepair:
            return Asset.Images.evTractorRepair.image
        case .piggysBirthday:
            return Asset.Images.evPiggysBirthday.image
        case .broomstickFlight:
            return Asset.Images.evBroomstickFlight.image
        case .potionBrewing:
            return Asset.Images.evPotionBrewing.image
        case .learningSpells:
            return Asset.Images.evLearningSpells.image
        case .duelDarkWizard:
            return Asset.Images.evDuelDarkWiz.image
        case .visitHauntedHouse:
            return Asset.Images.evVisHauntHouse.image
        case .highTower:
            return Asset.Images.evHighTower.image
        case .magicalForest:
            return Asset.Images.evMagForest.image
        case .woodlandCreatures:
            return Asset.Images.evWoodCreatures.image
        case .ball:
            return Asset.Images.evBall.image
        case .meetFairy:
            return Asset.Images.evMeetFairy.image
        case .greatBattle:
            return Asset.Images.evGreatBattle.image
        case .captureByTrolls:
            return Asset.Images.evCaptureByTrolls.image
        case .elvenRelics:
            return Asset.Images.evElvenRelics.image
        case .goblinDungeon:
            return Asset.Images.evGoblinDungeon.image
        case .darkForest:
            return Asset.Images.evDarkForest.image
        }
    }
    
    var description: String {
        switch self {
        case .shipwreck:
            return L10n.Event.Description.shipwreck
        case .dessertIsland:
            return L10n.Event.Description.exploreDesertIsland
        case .treasureChest:
            return L10n.Event.Description.findingTreasureChest
        case .seaBattle:
            return L10n.Event.Description.seaBattle
        case .portRaid:
            return L10n.Event.Description.raidingPort
        case .iceAge:
            return L10n.Event.Description.iceAge
        case .neanderthals:
            return L10n.Event.Description.encounterNeanderthals
        case .volcano:
            return L10n.Event.Description.volcanoEruption
        case .timeTravel:
            return L10n.Event.Description.timeTravel
        case .newFruits:
            return L10n.Event.Description.explorationOfNewFruits
        case .saveMeltCity:
            return L10n.Event.Description.savingCityFromMelting
        case .buildGingerHouse:
            return L10n.Event.Description.buildingGingerbreadHouse
        case .chocolateRiver:
            return L10n.Event.Description.journeyAlongChocolateRiver
        case .sweetSodaRain:
            return L10n.Event.Description.sweetSodaRain
        case .warWithSourKingdom:
            return L10n.Event.Description.warWithSourKingdom
        case .wolfPackAttack:
            return L10n.Event.Description.wolfPackAttack
        case .assistTheFarmer:
            return L10n.Event.Description.assistingFarmer
        case .rescueTheHarvest:
            return L10n.Event.Description.rescuingHarvest
        case .tractorRepair:
            return L10n.Event.Description.tractorRepair
        case .piggysBirthday:
            return L10n.Event.Description.piggyBirthday
        case .broomstickFlight:
            return L10n.Event.Description.broomstickFlight
        case .potionBrewing:
            return L10n.Event.Description.potionBrewing
        case .learningSpells:
            return L10n.Event.Description.learningSpells
        case .duelDarkWizard:
            return L10n.Event.Description.duelAgainstDarkWizard
        case .visitHauntedHouse:
            return L10n.Event.Description.visitHauntedHouse
        case .highTower:
            return L10n.Event.Description.imprisonmentInHighTower
        case .magicalForest:
            return L10n.Event.Description.enteringMagicalForest
        case .woodlandCreatures:
            return L10n.Event.Description.friendshipWithWoodlandCreatures
        case .ball:
            return L10n.Event.Description.ball
        case .meetFairy:
            return L10n.Event.Description.meetingFairy
        case .greatBattle:
            return L10n.Event.Description.greatBattle
        case .captureByTrolls:
            return L10n.Event.Description.captureByTrolls
        case .elvenRelics:
            return L10n.Event.Description.questForElvenRelics
        case .goblinDungeon:
            return L10n.Event.Description.exploringGoblinDungeon
        case .darkForest:
            return L10n.Event.Description.overcomingDarkForest
        }
    }
    
    var descriptionForPrompt: String {
        self.description
    }
}

// MARK: - SelectionStepCellDataSource
extension Event: SelectionStepCellDataSource {
    
    var id: Int {
        self.rawValue
    }
    
    var selectionStepCellImage: UIImage {
        self.image
    }
    
    var selectionStepCellText: String? {
        self.description
    }
    
    var shouldShowFrame: Bool {
        false
    }
    
    var imageScaleMultiplier: CGFloat {
        0.9
    }
}
