//
//  TokenAdapter.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 15/12/23.
//

import Foundation
import Alamofire

class TokenAdapter: RequestAdapter {
    
    private let tokensManager: TokensManager
    
    static let shared = TokenAdapter()
    
    private init() {
        self.tokensManager = TokensManager()
    }
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var newUrlRequest = urlRequest
        
        if let token = tokensManager.tokens?.accessToken {
            newUrlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(Result.success(newUrlRequest))
        
    }
}
