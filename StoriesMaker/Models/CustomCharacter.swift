//
//  CustomCharacter.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 13/09/2024.
//

import Foundation

struct CustomCharacter {
    private let id: String = UUID().uuidString
    let name: String
    let gender: Gender
    
    var descriptionForPrompt: String {
        self.gender.childRepresentation + " " + self.name
    }
}

extension CustomCharacter: Equatable {
    
    static func == (lhs: CustomCharacter, rhs: CustomCharacter) -> Bool {
        lhs.id == rhs.id
    }
}
