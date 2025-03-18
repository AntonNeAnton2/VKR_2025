//
//  Moral.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 09/09/2024.
//

import UIKit

enum Moral: Int, CaseIterable {
    
    case neverGiveUp
    case thinkBeforeYouAct
    case respectOthers
    case alwaysBeKind
    case beHonest
    case industriousness
    case learningToForgive
    case friendship
    case modesty
    
    var image: UIImage {
        switch self {
        case .neverGiveUp:
            return Asset.Images.moNevGivUp.image
        case .thinkBeforeYouAct:
            return Asset.Images.moThBeYoAct.image
        case .respectOthers:
            return Asset.Images.moRespOthers.image
        case .alwaysBeKind:
            return Asset.Images.moAlwBeKind.image
        case .beHonest:
            return Asset.Images.moBeHonest.image
        case .industriousness:
            return Asset.Images.moIndustr.image
        case .learningToForgive:
            return Asset.Images.moLearnToForg.image
        case .friendship:
            return Asset.Images.moFriendship.image
        case .modesty:
            return Asset.Images.moModesty.image
        }
    }
    
    var name: String {
        switch self {
        case .neverGiveUp:
            return L10n.Moral.Name.neverGiveUp
        case .thinkBeforeYouAct:
            return L10n.Moral.Name.thinkBeforeAct
        case .respectOthers:
            return L10n.Moral.Name.respectOthers
        case .alwaysBeKind:
            return L10n.Moral.Name.alwaysBeKind
        case .beHonest:
            return L10n.Moral.Name.beHonest
        case .industriousness:
            return L10n.Moral.Name.industriousness
        case .learningToForgive:
            return L10n.Moral.Name.learningToForgive
        case .friendship:
            return L10n.Moral.Name.friendship
        case .modesty:
            return L10n.Moral.Name.modesty
        }
    }
    
    var descriptionForPrompt: String {
        self.name
    }
}

// MARK: - SelectionStepCellDataSource
extension Moral: SelectionStepCellDataSource {
    var id: Int {
        return self.rawValue
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
