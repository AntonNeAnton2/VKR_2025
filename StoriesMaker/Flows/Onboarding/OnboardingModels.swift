//
//  OnboardingModels.swift
//  StoriesMaker
//
//  Created by borisenko on 11.09.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

enum Onboarding {}

extension Onboarding {
    
    enum Models {}
}

extension Onboarding.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onUpdateCurrentIndex: AnyPublisher<Int, Never>
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

extension Onboarding.Models {
    
    enum Step: CaseIterable {
        case welcome
        case experienceTheWonder
        case saveStories
        
        var title: String? {
            switch self {
            case .welcome:
                return L10n.Onboarding.firstPageTitle
            case .experienceTheWonder:
                return nil
            case .saveStories:
                return nil
            }
        }
        
        var description: String {
            switch self {
            case .welcome:
                return L10n.Onboarding.firstPageDesc
            case .experienceTheWonder:
                return L10n.Onboarding.secondPageDesc
            case .saveStories:
                return L10n.Onboarding.thirdPageDesc("")
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
