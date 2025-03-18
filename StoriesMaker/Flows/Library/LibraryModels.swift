//
//  LibraryModels.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 08/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

enum Library {}

extension Library {
    
    enum Models {}
}

extension Library.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onViewWillAppear: AnyPublisher<Void, Never>
        let onMakeStory: AnyPublisher<Void, Never>
        let onDeleteMyStory: AnyPublisher<MyStory, Never>
        let onSelectMyStory: AnyPublisher<MyStory, Never>
    }

    // MARK: Output
    enum ViewState: Equatable {
        case idle
    }

    enum ViewAction {
        case showMyStories([MyStory])
        case showEmptyState(Bool)
    }

    enum ViewRoute {
        case selectionStepFlow
        case story(MyStory)
        case subscription
    }
}

