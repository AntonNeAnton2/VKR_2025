//
//  StoryCreationModels.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 19/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

enum StoryCreation {}

extension StoryCreation {
    
    enum Models {}
}

extension StoryCreation.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onBackButtonTap: AnyPublisher<Void, Never>
        let onErrorDismiss: AnyPublisher<Void, Never>
    }

    // MARK: Output
    enum ViewState: Equatable {
        case idle
    }

    enum ViewAction {
        case showError(CustomError)
        case setProgress(Double)
        case setFact(String)
    }

    enum ViewRoute {
        case pop
        case story(MyStory)
    }
}

