//
//  HomeViewModel.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 15/12/23.
//

import Foundation

import Combine

class HomeViewModel: ObservableObject {
    private var apiService = ApiRestClient()
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var playlists: [Playlist] = []
    
    func fetch() {
        apiService.fetchMyPlaylists(page: 1)
            .sink{(dataResponse) in
                if dataResponse.error != nil {
                    print(dataResponse.error?.localizedDescription ?? "Error")
                } else {
                    self.playlists = self.convertApiResponseToPlaylist(dataResponse: dataResponse.value?.items)
                }
            }
            .store(in: &cancellableSet)
    }
    
    func refresh() {
        playlists = []
        fetch()
    }
    
    private func convertApiResponseToPlaylist(dataResponse: [ApiObjectPlaylist]?) -> [Playlist] {
        guard let items = dataResponse else { return [] }
        
        return items.map { item in
            Playlist(id: item.id,
                     name: item.name,
                     summary: item.summary,
                     ownerId: item.owner.id,
                     ownerName: item.owner.name ?? "",
                     image: item.defaultImage,
                     totalTracks: item.tracks.total
            )
        }
    }
}
