//
//  RealmFactory.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 22/09/2023.
//

import Foundation
import RealmSwift

protocol RealmFactory {
    
    static var shared: Self { get }
    
    static var configuration: Realm.Configuration { get }
    
    func realm() throws -> Realm
    func realm(queue: DispatchQueue?) throws -> Realm
}

extension RealmFactory {
    
    func realm() throws -> Realm {
        try Realm(configuration: Self.configuration)
    }
    
    func realm(queue: DispatchQueue?) throws -> Realm {
        try Realm(configuration: Self.configuration, queue: queue)
    }
}
