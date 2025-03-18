//
//  LocalMyStoriesStorage.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 22/09/2024.
//

import Foundation

protocol LocalMyStoriesStorage {
    func save(myStory: MyStory) -> Bool
    func delete(myStory: MyStory) -> Bool
    func getMyStories() -> [MyStory]
}
