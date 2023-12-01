//
//  Navigation.swift
//  spotify-demo
//
//  Created by Daniel Ferrer on 28/11/23.
//

import Foundation


struct Navigation: Hashable {
    
    let view: String
    
    static func == (lhs: Navigation, rhs: Navigation) -> Bool {
        lhs.view == rhs.view
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(view.self)
    }
    
}

