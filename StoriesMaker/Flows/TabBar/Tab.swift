//
//  Tab.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 04/09/2023.
//

import UIKit

enum Tab {
    case library
    case makeStory
    case settings
    
    var index: Int {
        switch self {
        case .library:
            return 0
        case .makeStory:
            return 1
        case .settings:
            return 2
        }
    }
    
    var image: UIImage? {
        switch self {
        case .library:
            return Asset.Images.tabLibrary.image
        case .makeStory:
            return Asset.Images.tabMakeStory.image
        case .settings:
            return Asset.Images.tabSettings.image
        }
    }
    
    var titleColor: UIColor? {
        switch self {
        case .library:
            return Asset.Colors.fdffc2.color
        case .makeStory:
            return Asset.Colors.fdffc2.color
        case .settings:
            return Asset.Colors.fdffc2.color
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .library:
            return Asset.Images.tabLibrarySelected.image
        case .makeStory:
            return Asset.Images.tabMakeStorySelected.image
        case .settings:
            return Asset.Images.tabSettingsSelected.image
        }
    }
    
    var selectedTitleColor: UIColor? {
        switch self {
        case .library:
            return Asset.Colors.e7Ea73.color
        case .makeStory:
            return Asset.Colors.e7Ea73.color
        case .settings:
            return Asset.Colors.e7Ea73.color
        }
    }
    
    var title: String {
        switch self {
        case .library:
            return L10n.library
        case .makeStory:
            return L10n.new
        case .settings:
            return L10n.Settings.settings
        }
    }
}
