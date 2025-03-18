//
//  StoryMapper.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 20/09/2023.
//

import Foundation

enum MyStoryMapper {
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        return df
    }()
    
    static func map(dto: MyStoryDTO) -> MyStory {
        .init(
            id: UUID().uuidString,
            name: dto.name,
            description: String(dto.text.prefix(100)),
            storyContent: dto.text,
            date: Date()
        )
    }
    
    static func map(dao: MyStoryDAO) -> MyStory {
        .init(
            id: dao.id,
            name: dao.name,
            description: dao.shortStoryDescription,
            storyContent: dao.storyContent,
            date: dao.date,
            universe: Universe(rawValue: dao.universe)
        )
    }
    
    static func mapToDao(myStory: MyStory) -> MyStoryDAO {
        .init(
            id: myStory.id,
            name: myStory.name,
            shortStoryDescription: myStory.description,
            storyContent: myStory.storyContent,
            date: myStory.date, 
            universe: myStory.universe?.rawValue ?? 0
        )
    }
}
