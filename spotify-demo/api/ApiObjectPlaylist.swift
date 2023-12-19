//
//  ApiObjectPlaylist.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 15/12/23.
//

import Foundation

struct ApiObjectPlaylist: Codable {
    
    var id: String
    var name: String
    var summary: String
    var images: [ApiObjectImage]?
    var owner: ApiObjectOwner
    var tracks: ApiObjectTotals
    
    enum CodingKeys: String, CodingKey {
            case id, name,
                 summary = "description",
                 images,
                 owner,
                tracks
        }
    
    var defaultImage: String? {
        images?.first?.url
    }
}

struct ApiObjectImage: Codable {
    var url: String
}

struct ApiObjectOwner: Codable {
    var id: String
    var name: String?
    
    enum CodingKeys: String, CodingKey {
            case id, name = "display_name"
        }
}

struct ApiObjectTotals: Codable {
    var total: Int
}
