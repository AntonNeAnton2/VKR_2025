//
//  Gender.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 13/09/2024.
//

import Foundation

enum Gender {
    
    case male
    case female
    
    var childRepresentation: String {
        switch self {
        case .male:
            return L10n.Gender.boy
        case .female:
            return L10n.Gender.girl
        }
    }
}
