//
//  Playlist.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 15/12/23.
//

import Foundation

struct Playlist: Identifiable {
    var id: String
    var name: String
    var summary: String
    var ownerId: String
    var ownerName: String
    var image: String?
    var totalTracks: Int
}
