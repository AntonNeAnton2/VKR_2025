//
//  SettingsModels.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 30/08/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine
import UIKit

enum Settings {}

extension Settings {
    
    enum Models {}
}

extension Settings.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onSelectSetting: AnyPublisher<Setting, Never>
        let onPrivacyPolicy: AnyPublisher<Void, Never>
        let onTermsOfUse: AnyPublisher<Void, Never>
        let onChangeLanguage: AnyPublisher<Void, Never>
        let onConfirmChangeLanguage: AnyPublisher<Void, Never>
    }

    // MARK: Output
    enum ViewState: Equatable {
        case idle
    }

    enum ViewAction {
        case showHelp(UIViewController)
        case showHelpFailure(String)
        case showRateUs(URL)
        case showShare(URL)
        case showLegalChoise
        case showLegal(URL)
        case showChangeLanguageAlert
    }

    enum ViewRoute {
        case youAreAllSet
        case settings
    }
}

extension Settings.Models {
    
    enum Setting {
        case help
        case rateUs
        case shareApp
        case privacyPolicyTermOfUse
        
        var icon: UIImage? {
            switch self {
            case .help:
                return UIImage(systemName: "lifepreserver.fill")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal)
            case .rateUs:
                return UIImage(systemName: "star.leadinghalf.filled")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal)
            case .shareApp:
                return UIImage(systemName: "heart.fill")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal)
            case .privacyPolicyTermOfUse:
                return UIImage(systemName: "lock.fill")?
                    .withTintColor(.white, renderingMode: .alwaysOriginal)
            }
        }
        
        var text: String {
            switch self {
            case .help:
                return L10n.Settings.help
            case .rateUs:
                return L10n.Settings.rateUs
            case .shareApp:
                return L10n.Settings.shareApp
            case .privacyPolicyTermOfUse:
                return L10n.Settings.privacyAndTerms
            }
        }
    }
}

