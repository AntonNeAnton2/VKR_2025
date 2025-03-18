//
//  LocalMyStoriesStorage.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 22/09/2023.
//

import Foundation

protocol LocalMyStoriesStorage {
    func save(myStory: MyStory) -> Bool
    func delete(myStory: MyStory) -> Bool
    func getMyStories() -> [MyStory]
}
