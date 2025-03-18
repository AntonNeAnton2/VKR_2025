//
//  MyStoriesRealmFactory.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 22/09/2024.
//

import Foundation
import RealmSwift

struct MyStoriesRealmFactory: RealmFactory {
    
    static let shared = MyStoriesRealmFactory()
    static var configuration: Realm.Configuration {
        Realm.Configuration(
            fileURL: Utilities.myStoriesRealmDirectoryURL
                .appendingPathComponent("myStories", isDirectory: false)
                .appendingPathExtension("realm"),
            schemaVersion: 0
        )
    }
    
    private init() { }
}
