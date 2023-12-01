//
//  SessionViewModel.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 28/11/23.
//

import Foundation

class SessionViewModel: ObservableObject {
    
    func logout() {
        let tokenManager = TokensManager()
        tokenManager.removeSession()
    }
    
}
