//
//  StoryModels.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 20.09.23.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine

enum Story {}

extension Story {
    
    enum Models {}
}

extension Story.Models {

    // MARK: Input
    struct ViewModelInput {
        let onLoad: AnyPublisher<Void, Never>
        let onBackButtonTap: AnyPublisher<Void, Never>
        let onSaveButtonTap: AnyPublisher<Void, Never>
    }

    // MARK: Output
    enum ViewState: Equatable {
        case idle
        case loaded(Configuration)
    }

    enum ViewAction {
        case saveButtonState(Story.Models.SaveButtonState)
    }

    enum ViewRoute {
        case dismiss
        case pop
    }
}


extension Story.Models {
    
    enum SaveButtonState {
        
        case hidden
        case active
        case inactive
    }
    
    enum BackButtonState {
        
        case pop
        case dismiss
    }
    
    final class Configuration: Equatable {
        
        enum EntryPoint {
            
            case storyCreation
            case library
        }
        
        let entryPoint: EntryPoint
        let story: MyStory
        let saveButtonState: SaveButtonState
        let backButtonState: BackButtonState
        let universe: Universe?
        
        init(
            entryPoint: EntryPoint,
            story: MyStory,
            saveButtonState: SaveButtonState,
            backButtonState: BackButtonState,
            universe: Universe?
        ) {
            self.entryPoint = entryPoint
            self.story = story
            self.saveButtonState = saveButtonState
            self.backButtonState = backButtonState
            self.universe = universe
        }
        
        static func == (
            lhs: Story.Models.Configuration,
            rhs: Story.Models.Configuration
        ) -> Bool {
            lhs.story.id == rhs.story.id
        }
    }
}
