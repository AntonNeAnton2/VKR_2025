//
//  MyStoryDAO.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 22/09/2024.
//

import Foundation
import RealmSwift

final class MyStoryDAO: Object, Identifiable {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var shortStoryDescription: String = ""
    @objc dynamic var storyContent: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var universe: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(
        id: String,
        name: String,
        shortStoryDescription: String,
        storyContent: String,
        date: Date,
        universe: Int
    ) {
        self.init()
        self.id = id
        self.name = name
        self.shortStoryDescription = shortStoryDescription
        self.storyContent = storyContent
        self.date = date
        self.universe = universe
    }
}
