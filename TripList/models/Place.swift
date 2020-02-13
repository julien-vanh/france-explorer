//
//  Place.swift
//  TripList
//
//  Created by Julien Vanheule on 19/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import CoreLocation

struct Place: Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var photocredits: String!
    var wikiPageId: Int!
    var regionId: String
    var category: PlaceCategory
    var website: String!
    var description: String!
    var source: String!
    var popularity: Int
    
    fileprivate var location: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
    }
    var cta: CallToAction!
}

struct PlaceRegion: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var domtom: Bool
}

enum PlaceCategory: String, CaseIterable, Codable, Hashable {
    case city = "city"
    case museum = "museum"
    case nature = "nature"
    case historical = "historical"
    case event = "event"
}

struct Coordinates: Hashable, Codable {
    var lat: Double
    var lon: Double
}

struct CallToAction: Hashable, Codable {
    var title: String
    var link: String
}
