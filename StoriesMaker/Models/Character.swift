//
//  Character.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 09/09/2024.
//

import UIKit

enum Character: Int {
    
    // MARK: Pirates' Paradise
    case parrot
    case piratesCaptain
    case commodoreOfRoyalNavy
    case youngPirate
    case piratesCaptainsDaughter
    
    // MARK: Dino Island
    case rexie
    case ptero
    case diplo
    case polly
    case tricey
    
    // MARK: Candy Land
    case gingy
    case marshmallowGuy
    case cottonCandyCloud
    case choccoFroggo
    case missStrawberry
    
    // MARK: Animal Farm
    case sheep
    case puppy
    case kitty
    case donkey
    case hen
    
    // MARK: Wizard School
    case youngWizard
    case youngWitch
    case potionsMaster
    case schoolHeadmaster
    case ghost
    
    // MARK: Princess Castle
    case princess
    case kingAndQueen
    case prince
    case whiteHorse
    case dragon
    
    // MARK: Mistwood
    case dwarf
    case elf
    case knight
    case orc
    case wizard
    
    static var piratesParadiseCharacters: [Character] {
        [
            .parrot,
            .piratesCaptain,
            .commodoreOfRoyalNavy,
            .youngPirate,
            .piratesCaptainsDaughter
        ]
    }
    
    static var dinoIslandCharacters: [Character] {
        [
            .rexie,
            .ptero,
            .diplo,
            .polly,
            .tricey
        ]
    }
    static var candyLandCharacters: [Character] {
        [
            .gingy,
            .marshmallowGuy,
            .cottonCandyCloud,
            .choccoFroggo,
            .missStrawberry
        ]
    }
    
    static var animalFarmCharacters: [Character] {
        [
            .sheep,
            .puppy,
            .kitty,
            .donkey,
            .hen
        ]
    }
    
    static var wizardSchoolCharacters: [Character] {
        [
            .youngWizard,
            .youngWitch,
            .potionsMaster,
            .schoolHeadmaster,
            .ghost
        ]
    }
    
    static var princessCastleCharacters: [Character] {
        [
            .princess,
            .kingAndQueen,
            .prince,
            .whiteHorse,
            .dragon
        ]
    }
    
    static var mistwoodCharacters: [Character] {
        [
            .dwarf,
            .elf,
            .knight,
            .orc,
            .wizard
        ]
    }
    
    var image: UIImage {
        switch self {
        case .parrot:
            return Asset.Images.chParrot.image
        case .piratesCaptain:
            return Asset.Images.chPirateCap.image
        case .commodoreOfRoyalNavy:
            return Asset.Images.chComOfRoyNavy.image
        case .youngPirate:
            return Asset.Images.chYoungPirate.image
        case .piratesCaptainsDaughter:
            return Asset.Images.chPirCapDaughter.image
        case .rexie:
            return Asset.Images.chRexie.image
        case .ptero:
            return Asset.Images.chPtero.image
        case .diplo:
            return Asset.Images.chDiplo.image
        case .polly:
            return Asset.Images.chPolly.image
        case .tricey:
            return Asset.Images.chTricey.image
        case .gingy:
            return Asset.Images.chGingy.image
        case .marshmallowGuy:
            return Asset.Images.chMarshmallow.image
        case .cottonCandyCloud:
            return Asset.Images.chCotCanCloud.image
        case .choccoFroggo:
            return Asset.Images.chChoFro.image
        case .missStrawberry:
            return Asset.Images.chMsStrawberry.image
        case .sheep:
            return Asset.Images.chSheep.image
        case .puppy:
            return Asset.Images.chPuppy.image
        case .kitty:
            return Asset.Images.chKitty.image
        case .donkey:
            return Asset.Images.chDonkey.image
        case .hen:
            return Asset.Images.chHen.image
        case .youngWizard:
            return Asset.Images.chYoungWizard.image
        case .youngWitch:
            return Asset.Images.chYoungWitch.image
        case .potionsMaster:
            return Asset.Images.chPotionsMaster.image
        case .schoolHeadmaster:
            return Asset.Images.chSchoolHead.image
        case .ghost:
            return Asset.Images.chGhost.image
        case .princess:
            return Asset.Images.chPrincess.image
        case .kingAndQueen:
            return Asset.Images.chKingNQueen.image
        case .prince:
            return Asset.Images.chPrince.image
        case .whiteHorse:
            return Asset.Images.chWhiteHorse.image
        case .dragon:
            return Asset.Images.chDragon.image
        case .dwarf:
            return Asset.Images.chDwarf.image
        case .elf:
            return Asset.Images.chElf.image
        case .knight:
            return Asset.Images.chKnight.image
        case .orc:
            return Asset.Images.chOrc.image
        case .wizard:
            return Asset.Images.chWizard.image
        }
    }
    
    var name: String {
        switch self {
        case .parrot:
            return L10n.Character.Name.parrot
        case .piratesCaptain:
            return L10n.Character.Name.piratesCaptain
        case .commodoreOfRoyalNavy:
            return L10n.Character.Name.commodoreOfRoyalNavy
        case .youngPirate:
            return L10n.Character.Name.youngPirate
        case .piratesCaptainsDaughter:
            return L10n.Character.Name.piratesCaptainDaughter
        case .rexie:
            return L10n.Character.Name.rexie
        case .ptero:
            return L10n.Character.Name.ptero
        case .diplo:
            return L10n.Character.Name.diplo
        case .polly:
            return L10n.Character.Name.polly
        case .tricey:
            return L10n.Character.Name.tricey
        case .gingy:
            return L10n.Character.Name.gingy
        case .marshmallowGuy:
            return L10n.Character.Name.marshmallowGuy
        case .cottonCandyCloud:
            return L10n.Character.Name.cottonCandyCloud
        case .choccoFroggo:
            return L10n.Character.Name.choccoFroggo
        case .missStrawberry:
            return L10n.Character.Name.missStrawberry
        case .sheep:
            return L10n.Character.Name.sheep
        case .puppy:
            return L10n.Character.Name.puppy
        case .kitty:
            return L10n.Character.Name.kitty
        case .donkey:
            return L10n.Character.Name.donkey
        case .hen:
            return L10n.Character.Name.hen
        case .youngWizard:
            return L10n.Character.Name.youngWizard
        case .youngWitch:
            return L10n.Character.Name.youngWitch
        case .potionsMaster:
            return L10n.Character.Name.potionsMaster
        case .schoolHeadmaster:
            return L10n.Character.Name.schoolHeadmaster
        case .ghost:
            return L10n.Character.Name.ghost
        case .princess:
            return L10n.Character.Name.princess
        case .kingAndQueen:
            return L10n.Character.Name.kingAndQueen
        case .prince:
            return L10n.Character.Name.prince
        case .whiteHorse:
            return L10n.Character.Name.whiteHorse
        case .dragon:
            return L10n.Character.Name.dragon
        case .dwarf:
            return L10n.Character.Name.dwarf
        case .elf:
            return L10n.Character.Name.elf
        case .knight:
            return L10n.Character.Name.knight
        case .orc:
            return L10n.Character.Name.orc
        case .wizard:
            return L10n.Character.Name.wizard
        }
    }
    
    var descriptionForPrompt: String {
        switch self {
        case .parrot:
            return L10n.Character.Prompt.Description.parrot
        case .piratesCaptain:
            return L10n.Character.Prompt.Description.piratesCaptain
        case .commodoreOfRoyalNavy:
            return L10n.Character.Prompt.Description.commodoreOfRoyalNavy
        case .youngPirate:
            return L10n.Character.Prompt.Description.youngPirate
        case .piratesCaptainsDaughter:
            return L10n.Character.Prompt.Description.piratesCaptainDaughter
        case .rexie:
            return L10n.Character.Prompt.Description.rexie
        case .ptero:
            return L10n.Character.Prompt.Description.ptero
        case .diplo:
            return L10n.Character.Prompt.Description.diplo
        case .polly:
            return L10n.Character.Prompt.Description.polly
        case .tricey:
            return L10n.Character.Prompt.Description.tricey
        case .gingy:
            return L10n.Character.Prompt.Description.gingy
        case .marshmallowGuy:
            return L10n.Character.Prompt.Description.marshmallowGuy
        case .cottonCandyCloud:
            return L10n.Character.Prompt.Description.cottonCandyCloud
        case .choccoFroggo:
            return L10n.Character.Prompt.Description.choccoFroggo
        case .missStrawberry:
            return L10n.Character.Prompt.Description.missStrawberry
        case .sheep:
            return L10n.Character.Prompt.Description.sheep
        case .puppy:
            return L10n.Character.Prompt.Description.puppy
        case .kitty:
            return L10n.Character.Prompt.Description.kitty
        case .donkey:
            return L10n.Character.Prompt.Description.donkey
        case .hen:
            return L10n.Character.Prompt.Description.hen
        case .youngWizard:
            return L10n.Character.Prompt.Description.youngWizard
        case .youngWitch:
            return L10n.Character.Prompt.Description.youngWitch
        case .potionsMaster:
            return L10n.Character.Prompt.Description.potionsMaster
        case .schoolHeadmaster:
            return L10n.Character.Prompt.Description.schoolHeadmaster
        case .ghost:
            return L10n.Character.Prompt.Description.ghost
        case .princess:
            return L10n.Character.Prompt.Description.princess
        case .kingAndQueen:
            return L10n.Character.Prompt.Description.kingAndQueen
        case .prince:
            return L10n.Character.Prompt.Description.prince
        case .whiteHorse:
            return L10n.Character.Prompt.Description.whiteHorse
        case .dragon:
            return L10n.Character.Prompt.Description.dragon
        case .dwarf:
            return L10n.Character.Prompt.Description.dwarf
        case .elf:
            return L10n.Character.Prompt.Description.elf
        case .knight:
            return L10n.Character.Prompt.Description.knight
        case .orc:
            return L10n.Character.Prompt.Description.orc
        case .wizard:
            return L10n.Character.Prompt.Description.wizard
        }
    }
}

// MARK: - SelectionStepCellDataSource
extension Character: SelectionStepCellDataSource {
    
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
        true
    }
    
    var imageScaleMultiplier: CGFloat {
        0.6
    }
}
