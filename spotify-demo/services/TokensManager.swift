//
//  TokensManager.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 28/11/23.
//


import Foundation
import Valet
import AppAuthCore

struct Tokens {
    let accessToken: String
    let refreshToken: String
    let idToken: String?
}

class TokensManager {
    
    enum TokenKeyNames: String {
        case accessToken, refreshToken, idToken
    }
    
    private var _valet: Valet? {
        guard let identifier = Identifier(nonEmpty: "dev.codewithferrer.spotifydemo") else { return nil }
        return Valet.valet(with: identifier, accessibility: .afterFirstUnlock)
    }
    
    private func save(key: TokenKeyNames, value: String) {
        try? _valet?.setString(value, forKey: key.rawValue)
    }
    
    private func get(key: TokenKeyNames) -> String? {
        return try? _valet?.string(forKey: key.rawValue)
    }
    
    func save(response: OIDTokenResponse) {
        
        guard let accessToken = response.accessToken,
              let refreshToken = response.refreshToken
        else { return }
        
        
        save(key: .accessToken, value: accessToken)
        save(key: .refreshToken, value: refreshToken)
        if let idToken = response.idToken {
            save(key: .idToken, value: idToken)
        }
    }
    
    func removeSession() {
        try? _valet?.removeAllObjects()
    }
    
    var tokens: Tokens? {
        guard let accessToken = get(key: .accessToken),
              let refreshToken = get(key: .refreshToken)
        else { return nil }
        let idToken = get(key: .idToken)
        
        return Tokens(accessToken: accessToken,
                      refreshToken: refreshToken,
                      idToken: idToken)
    }
    
    var userIsLogged: Bool {
        return tokens != nil
    }
}
