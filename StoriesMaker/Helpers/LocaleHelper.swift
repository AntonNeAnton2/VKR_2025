//
//  LocaleHelper.swift
//  StoriesMaker
//
//  Created by borisenko on 31.10.2023.
//

import Foundation

typealias Language = LocaleHelper.Language

enum LocaleHelper {
    
    enum Language {
        case english
        case russian
        case german
        case unknown
    }
    
    static func getCurrentLanguage() -> Language {
        switch Locale.current.languageCode {
        case "en":
            return .english
        case "ru":
            return .russian
        case "de":
            return .german
        default:
            return .unknown
        }
    }
}
