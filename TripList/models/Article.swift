//
//  Article.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation

struct Article: Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var places: [String]
}
