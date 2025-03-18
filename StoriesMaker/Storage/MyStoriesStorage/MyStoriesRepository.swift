//
//  MyStoriesRepository.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 22/09/2024.
//

import Foundation

final class MyStoriesRepository {

    static let shared = MyStoriesRepository()
    
    private let storage: LocalMyStoriesStorage = RealmMyStoriesStorage()
    
    private var myStoriesCache = Set<MyStory>()
    private var haveFetchedFromStorage = false
    
    private init() {}
    
    func save(myStory: MyStory) {
        let result = self.storage.save(myStory: myStory)
        if result {
            self.myStoriesCache.insert(myStory)
        }
    }
    
    func delete(myStory: MyStory) {
        let result = self.storage.delete(myStory: myStory)
        if result {
            self.myStoriesCache.remove(myStory)
        }
    }
    
    func getMyStories() -> [MyStory] {
        if !self.haveFetchedFromStorage {
            let results = self.storage.getMyStories()
            results.forEach { self.myStoriesCache.insert($0) }
            self.haveFetchedFromStorage = true
            return results
        } else {
            return Array(self.myStoriesCache)
        }
    }
}
