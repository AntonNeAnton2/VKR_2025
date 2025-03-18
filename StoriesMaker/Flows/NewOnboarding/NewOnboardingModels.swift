//
//  NewOnboardingModels.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 6.12.24.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine
import UIKit

enum NewOnboarding {}

extension NewOnboarding {
    
    enum Models {}
}

extension NewOnboarding.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
    }

    // MARK: Output
    enum ViewState: Equatable {
        case idle
    }

    enum ViewAction {
    }

    enum ViewRoute {
    }
}

extension NewOnboarding.Models {
    
    enum Step: CaseIterable {
        case welcome
        case saveStories
        case experienceTheWonder
        
        var title: String {
            switch self {
            case .welcome:
                return L10n.Onboarding.firstPageTitle
            case .saveStories:
                return L10n.Onboarding.secondPageTitle
            case .experienceTheWonder:
                return L10n.Onboarding.thirdPageTitle
            }
        }
        
        var description: String {
            switch self {
            case .welcome:
                return L10n.Onboarding.firstPageDesc
            case .experienceTheWonder:
                return L10n.Onboarding.secondPageDesc
            case .saveStories:
                return L10n.Onboarding.thirdPageDesc("3$")
            }
        }
        
        var stepImage: UIImage {
            switch self {
            case .welcome:
                return UIImage(named: "ondoarding-step-1") ?? UIImage()
            case .experienceTheWonder:
                return UIImage(named: "ondoarding-step-2") ?? UIImage()
            case .saveStories:
                return UIImage(named: "ondoarding-step-3") ?? UIImage()
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .welcome:
                return L10n.Onboarding.continue
            case .experienceTheWonder:
                return L10n.Onboarding.continue
            case .saveStories:
                return L10n.Onboarding.letsStart
            }
        }
        
        var backgroundImage: UIImage {
            switch self {
            case .welcome:
                return isIpad() ? Asset.Images.onboardingFirstPageBackgroundIpad.image :
                    Asset.Images.onboardingFirstPageBackground.image
            case .experienceTheWonder:
                return isIpad() ? Asset.Images.onboardingSecondPageBackgroundIpad.image :
                    Asset.Images.onboardingSecondPageBackground.image
            case .saveStories:
                return isIpad() ? Asset.Images.onboardingThirdPageBackgroundIpad.image :
                    Asset.Images.onboardingThirdPageBackground.image
            }
        }
    }
}

