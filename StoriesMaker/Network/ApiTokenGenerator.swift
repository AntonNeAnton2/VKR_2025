//
//  ApiTokenGenerator.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 20/09/2023.
//

import Foundation
import SwiftyRSA
import ArkanaKeys

struct ApiTokenGenerator {
    
    private static let publicKey: String = ArkanaKeys.Keys.Global().allianceApiTokenPublicKey
    private static let passphrase: String = ArkanaKeys.Keys.Global().allianceApiTokenPassphrase
    
    static func makeToken() -> String? {
        let keyPhrase = Self.passphrase
        let separator = "/"
        var dateString = String(Date().timeIntervalSince1970)
        dateString = String(dateString.prefix(while: { $0 != "." }))
        let result = keyPhrase + separator + dateString
        let encryptedResult = Self.encrypt(input: result)
        return encryptedResult
    }
    
    private static func encrypt(input: String) -> String? {
        guard let publicKey = try? PublicKey(pemEncoded: Self.publicKey),
              let clear = try? ClearMessage(string: input, using: .utf8),
              let encrypted = try? clear.encrypted(with: publicKey, padding: .PKCS1) else { return nil }
        let base64String = encrypted.base64String
        return base64String
    }
}
