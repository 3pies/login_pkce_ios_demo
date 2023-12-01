//
//  LoginViewModel.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 28/11/23.
//

import Foundation
import AppAuthCore
import UIKit

class LoginViewModel: ObservableObject {
    
    @Published var isLogged: Bool = false
    private var currentAuthorizationFlow: OIDExternalUserAgentSession? = nil
    
    func login() {
        guard let discoverURL = URL(string: AppConstants.spotifyDiscoverURL) else {
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forDiscoveryURL: discoverURL) {configuration, error in
            guard let configuration = configuration else { return }
            print(configuration)
            
            self.requestAuthorization(configuration: configuration)
        }
    }
    
    private func requestAuthorization(configuration: OIDServiceConfiguration) {
        guard let callbackURL = URL(string: AppConstants.spotifyCallbackURL) else { return }
        
        let scenes = UIApplication.shared.connectedScenes
        guard
              let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let controller = window.rootViewController
        else { return }
        
        let agent = OIDExternalUserAgentIOSSafariViewController(presentingViewController: controller)
        
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: AppConstants.spotifyClientID,
            scopes: ["user-read-private", "user-read-email"],
            redirectURL: callbackURL,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil)
        
        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request,
                                       externalUserAgent: agent) { [weak self] authState, error in
            if let authState = authState,
                let tokenResponse = authState.lastTokenResponse {
                
                let tokensManager = TokensManager()
                tokensManager.save(response: tokenResponse)
                self?.isLogged = true
            }
            
            agent.dismiss(animated: false, completion: {})
            self?.currentAuthorizationFlow = nil
        }
        
    }
    
    func handleUrl(url: URL) {
        currentAuthorizationFlow?.resumeExternalUserAgentFlow(with: url)
    }
    
    func checkIsLogged() {
        Task {
            try await Task.sleep(nanoseconds: 300_000_000)
            let tokensManager = TokensManager()
            await MainActor.run {
                if tokensManager.userIsLogged == true {
                    isLogged = true
                }
            }
        }
    }
    
}
