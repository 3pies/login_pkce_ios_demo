//
//  ApiService.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 15/12/23.
//

import Foundation
import Combine
import Alamofire

struct ApiRestError: Error {
  let error: Error
  let serverError: ServerError?
}

struct ServerError: Codable, Error {
    var status: String
    var message: String
}

struct ConfigError: Error {
    var code: Int
    var message: String
}


protocol ApiServiceProtocol {
    
    func fetchMyPlaylists(page: Int) -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectPlaylist>, ApiRestError>, Never>
    
}

class ApiRestClient {
    
    private let sessionManager: Session
    
    
    private let urlBase: String = "https://api.spotify.com/v1/"
    private let limit: Int = 8
    
    public init() {
        
        let afConfiguration = URLSessionConfiguration.af.default
        
        let interceptor = Interceptor(adapters: [TokenAdapter.shared], retriers: [RefreshTokenRetrier.shared])
        
        self.sessionManager = Session(configuration: afConfiguration,
                                      interceptor: interceptor,
                                      eventMonitors: [ AlamofireLogger(logLevel: .Body) ])
    }
}

extension ApiRestClient: ApiServiceProtocol {
    
    func fetchMyPlaylists(page: Int) -> AnyPublisher<DataResponse<ApiObjectPaginator<ApiObjectPlaylist>, ApiRestError>, Never> {
        
        let offset = (page - 1) * limit
        
        guard let url = URL(string: "\(urlBase)me/playlists?limit=\(limit)&offset=\(offset)") else {
                return emptyPublisher(error: ConfigError(code: 555, message: "No URL defined"))
        }
        
        return sessionManager.request(url, method: .get)
            .proccessResponse(type: ApiObjectPaginator<ApiObjectPlaylist>.self)
            
    }
    
    
    private func emptyPublisher<T: Codable>(error: ConfigError) -> AnyPublisher<DataResponse<T, ApiRestError>, Never> {
            
            return Just<DataResponse<T, ApiRestError>>(
                DataResponse(request: nil,
                             response: nil,
                             data: nil,
                             metrics: nil,
                             serializationDuration: 0,
                             result: .failure(ApiRestError(error: error, serverError: nil))
                            )
            )
            .eraseToAnyPublisher()
            
        }
    
}

extension DataRequest {
    
    func proccessResponse<T: Codable>(type: T.Type) -> AnyPublisher<DataResponse<T, ApiRestError>, Never> {
        validate()
        .publishDecodable(type: type.self)
        .map { response in
            response.mapError { error in
                let serverError = response.data.flatMap { try? JSONDecoder().decode(ServerError.self, from: $0)}
                return ApiRestError(error: error, serverError: serverError)
                
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}


