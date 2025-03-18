//
//  MakeStoryModels.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 08/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

enum MakeStory {}

extension MakeStory {
    
    enum Models {}
}

extension MakeStory.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onMakeStory: AnyPublisher<Void, Never>
    }

    // MARK: Output
    enum ViewState: Equatable {
        case idle
    }

    enum ViewAction {
    }

    enum ViewRoute {
        case selectionStepFlow
        case subscription
    }
}

