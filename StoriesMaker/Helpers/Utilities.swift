//
//  Utilities.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 22/09/2024.
//

import Foundation

enum Utilities {
    
    private static var applicationSupportDirectoryURL: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent(Bundle.main.bundleIdentifier ?? "", isDirectory: true) ?? URL(fileURLWithPath: "")
    }
    
    private static var documentDirectoryURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: "")
    }
    
    // MARK: My stories
    static var myStoriesRealmDirectoryURL: URL {
        Self.applicationSupportDirectoryURL
            .appendingPathComponent("My Stories", isDirectory: true)
            .appendingPathComponent("Realm", isDirectory: true)
    }
    
    static var myStoriesMediaDirectoryURL: URL {
        Self.documentDirectoryURL
            .appendingPathComponent("My Stories", isDirectory: true)
            .appendingPathComponent("Media", isDirectory: true)
    }
}

// MARK: - Helpers
extension Utilities {
    
    static func createDirectoryIfNeeded(at directoryURL: URL) throws {
        let fileManager = FileManager.default
        guard !fileManager.fileExists(atPath: directoryURL.path) else { return }
        
        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}
