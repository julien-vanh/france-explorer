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
    var region: PlaceRegion
    var popularity: Int
    var description: String
    var source: String
    var category: PlaceCategory
    fileprivate var location: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: location.lat,
            longitude: location.lon)
    }
    var cta: CallToAction!
}

enum PlaceRegion: String, CaseIterable, Codable, Hashable {
    case normandie = "normandie"
    case paris = "paris"
}

enum PlaceCategory: String, CaseIterable, Codable, Hashable {
    case visit = "visit"
    case place = "place"
    case activity = "activity"
}

struct Coordinates: Hashable, Codable {
    var lat: Double
    var lon: Double
}

struct CallToAction: Hashable, Codable {
    var title: String
    var link: String
}
