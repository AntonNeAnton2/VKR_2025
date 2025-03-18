//
//  MyStory.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 18.09.23.
//

import Foundation

final class MyStory {
    let id: String
    let name: String
    let description: String
    let storyContent: String
    let date: Date
    var universe: Universe?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    lazy var dateString: String = self.dateFormatter.string(from: self.date)
    
    init(id: String,
         name: String,
         description: String,
         storyContent: String,
         date: Date,
         universe: Universe? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.storyContent = storyContent
        self.date = date
        self.universe = universe
    }
}

// MARK: - Equatable
extension MyStory: Equatable {

    static func == (lhs: MyStory, rhs: MyStory) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension MyStory: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: - Mock
extension MyStory {
    
    static var stories: [MyStory] =
        .init([
            MyStory(id: "0",
                    name: "Cinderella",
                    description: "Long, long ago there lived a young and very beautiful girl called Cinderella.Cinderella lived with...",
                    storyContent: "",
                    date: Date(), 
                    universe: .princessCastle),
            MyStory(id: "0",
                    name: "Cinderella",
                    description: "Long, long ago there lived a young and very beautiful girl called Cinderella.Cinderella lived with...",
                    storyContent: "",
                    date: Date(),
                    universe: .princessCastle),
            MyStory(id: "0",
                    name: "Cinderella",
                    description: "Long, long ago there lived a young and very beautiful girl called Cinderella.Cinderella lived with...",
                    storyContent: "",
                    date: Date(),
                    universe: .princessCastle),
            MyStory(id: "0",
                    name: "Cinderella",
                    description: "Long, long ago there lived a young and very beautiful girl called Cinderella.Cinderella lived with...",
                    storyContent: "",
                    date: Date(),
                    universe: .princessCastle),
            MyStory(id: "0",
                    name: "Cinderella",
                    description: "Long, long ago there lived a young and very beautiful girl called Cinderella.Cinderella lived with...",
                    storyContent: "",
                    date: Date(),
                    universe: .princessCastle),
            MyStory(id: "0",
                    name: "Cinderella",
                    description: "Long, long ago there lived a young and very beautiful girl called Cinderella.Cinderella lived with...",
                    storyContent: "",
                    date: Date(),
                    universe: .princessCastle),
            MyStory(id: "0",
                    name: "Cinderella",
                    description: "Long, long ago there lived a young and very beautiful girl called Cinderella.Cinderella lived with...",
                    storyContent: "Cinderella",
                    date: Date(),
                    universe: .princessCastle),
        ])
}
