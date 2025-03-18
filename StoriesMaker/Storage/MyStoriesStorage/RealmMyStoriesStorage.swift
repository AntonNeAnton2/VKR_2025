//
//  RealmMyStoriesStorage.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 22/09/2024.
//

import Foundation
import RealmSwift

final class RealmMyStoriesStorage {
    
    private var realm: Realm? {
        try? MyStoriesRealmFactory.shared.realm()
    }
}

// MARK: - LocalMyStoriesStorage
extension RealmMyStoriesStorage: LocalMyStoriesStorage {
    
    func save(myStory: MyStory) -> Bool {
        try? Utilities.createDirectoryIfNeeded(at: Utilities.myStoriesRealmDirectoryURL)
        guard let realm = self.realm else { return false }
        let myStoryDAO = MyStoryMapper.mapToDao(myStory: myStory)
        
        do {
            try realm.write {
                realm.add(myStoryDAO)
            }
            return true
        } catch {
            return false
        }
    }
    
    func delete(myStory: MyStory) -> Bool {
        guard let realm = self.realm,
              let myStoryDAO = realm.object(ofType: MyStoryDAO.self, forPrimaryKey: myStory.id) else { return false }
        
        do {
            try realm.write {
                realm.delete(myStoryDAO)
            }
            return true
        } catch {
            return false
        }
    }
    
    func getMyStories() -> [MyStory] {
        guard let realm = self.realm else { return [] }
        let myStoriesDAOs = realm.objects(MyStoryDAO.self)
        let myStories: [MyStory] = myStoriesDAOs.map { MyStoryMapper.map(dao: $0) }
        return myStories
    }
}
