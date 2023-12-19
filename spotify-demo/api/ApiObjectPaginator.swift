//
//  ApiObjectPaginator.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 15/12/23.
//

import Foundation

struct ApiObjectPaginator<T: Codable>: Codable {
    
    var limit: Int
    var total: Int
    
    var items: [T]
    
}
