//
//  RefreshTokenRetrier.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 15/12/23.
//

import Foundation
import Alamofire
import AppAuth

class RefreshTokenRetrier: RequestRetrier {
    
    private var requestsToRetry: [(RetryResult) -> Void] = []
    private var isRefreshing = false
    private var tokensManager: TokensManager
    
    static let shared = RefreshTokenRetrier()
    
    private init() {
        self.tokensManager = TokensManager()
    }
    
    func retry(_ request: Alamofire.Request,
               for session: Alamofire.Session,
               dueTo error: Error,
               completion: @escaping (Alamofire.RetryResult) -> Void) {
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                isRefreshing = true
                refreshToken { success in
                    
                    self.requestsToRetry.forEach { $0(success ? .retry : .doNotRetry) }
                    self.requestsToRetry.removeAll()
                    self.isRefreshing = false
                    
                }
            }
        } else {
            completion(.doNotRetry)
        }
        
    }
    
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let discoverURL = URL(string: AppConstants.spotifyDiscoverURL) else {
            completion(false)
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forDiscoveryURL: discoverURL) {configuration, error in
            guard let configuration = configuration else {
                completion(false)
                return
            }
            
            self.requestAuthorization(configuration: configuration, completion: completion)
        }
    }
    
    private func requestAuthorization(configuration: OIDServiceConfiguration, completion: @escaping (Bool) -> Void) {
        guard let refreshToken = tokensManager.tokens?.refreshToken else {
            completion(false)
            return
        }
        
        let request = OIDTokenRequest(
                    configuration: configuration,
                    grantType: OIDGrantTypeRefreshToken,
                    authorizationCode: nil,
                    redirectURL: nil,
                    clientID: AppConstants.spotifyClientID,
                    clientSecret: nil,
                    scopes: AppConstants.spotifyScopes,
                    refreshToken: refreshToken,
                    codeVerifier: nil,
                    additionalParameters: nil)

        OIDAuthorizationService.perform(request) { response, error in
            
            if let response = response {
                self.tokensManager.save(response: response)
                completion(true)
                return
            }
            
            completion(false)
            return
        }
        
    }
    
}
