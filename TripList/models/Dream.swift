//
//  Dream.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation

struct Dream: Hashable, Codable, Identifiable {
    
    var id = UUID()
    var title: String
    var note: String
    var completed: Bool
    var placeId: String
    
    init(place: Place){
        self.title = place.title
        self.completed = false
        self.note = ""
        self.placeId = place.id
    }
}
