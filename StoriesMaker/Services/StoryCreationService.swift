//
//  StoryCreationService.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 20/09/2023.
//

import Foundation

final class StoryCreationService {
    
    private let openAIService = OpenAIService()
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createStory(
        with config: StoryConfiguation,
        completion: @escaping (Result<MyStory, CustomError>) -> Void
    ) {
        guard let prompt = self.makeStoryCreationPrompt(with: config) else {
            completion(.failure(.storyCreation(nil)))
            return
        }
        self.openAIService.sendRequest(with: prompt) { [weak self] result in
            switch result {
            case .success(let responseString):
                self?.handleResponseString(
                    responseString,
                    universe: config.universe,
                    completion: completion
                )
            case .failure(let error):
                completion(.failure(.storyCreation(error.cUnderlyingSwiftError)))
            }
        }
    }
    
    func cancelStoryCreation() {
        self.openAIService.cancelCurrentTask()
    }
}

private extension StoryCreationService {
    
    func makeStoryCreationPrompt(with config: StoryConfiguation) -> String? {
        guard let universe = config.universe,
              let characters = config.characters,
              let events = config.events,
              let moral = config.moral else { return nil }
        
        var additionalCharactersSubPrompt: String = ""
        if let customCharacters = config.customCharacters, !customCharacters.isEmpty {
            let customCharactersList = customCharacters
                .map { $0.descriptionForPrompt }
                .joined(separator: ", ")
            let customCharactersSubPart = customCharacters.count > 1 ?
                L10n.StoryCreationService.childrenForWhom :
                L10n.StoryCreationService.childForWhom
            
            additionalCharactersSubPrompt = L10n.StoryCreationService.customCharactersSubPrompt(
                customCharactersList,
                customCharactersSubPart
            )
        }
        
        let universePromptDescription = universe.descriptionForPrompt
        let mainCharactersList = characters
            .map { $0.descriptionForPrompt }
            .joined(separator: ", ")
        let eventsList = events
            .map { $0.descriptionForPrompt }
            .joined(separator: ", ")
        let moralPromptDescription = moral.descriptionForPrompt
        
        let prompt = L10n.StoryCreationService.prompt(
            universePromptDescription,
            mainCharactersList,
            additionalCharactersSubPrompt,
            eventsList,
            moralPromptDescription
        )
        
        return prompt
    }
    
    func handleResponseString(
        _ string: String,
        universe: Universe?,
        completion: @escaping (Result<MyStory, CustomError>) -> Void
    ) {
        guard let data = string.data(using: .utf8) else {
            let error = CustomError.storyCreation(nil)
            completion(.failure(error))
            return
        }
        
        do {
            let storyDTO = try self.jsonDecoder.decode(MyStoryDTO.self, from: data)
            let story = MyStoryMapper.map(dto: storyDTO)
            story.universe = universe
            completion(.success(story))
        } catch {
            let cError = CustomError.storyCreation(error)
            completion(.failure(cError))
        }
    }
}
