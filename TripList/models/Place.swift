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
    var category: PlaceCategory
    var regionId: String
    var iap: Bool
    var popularity: Int
    
    fileprivate var position: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: position.lat, longitude: position.lon)
    }
    var address: String!
    var website: String!
    
    var illustration: PlaceIllustration
    var photocredits: String!
    
    fileprivate var descriptionFr: PlaceDescription
    fileprivate var descriptionEn: PlaceDescription
    var description: PlaceDescription {
        if( Locale.current.languageCode == "fr"){
            return descriptionFr
        } else {
            return descriptionEn
        }
    }
    
    var wikiPageId: String!
    
    var cta: CallToAction!
}

struct PlaceIllustration: Hashable, Codable {
    var path: String
    var description: String
    var credit: String
    var source: String
}

struct PlaceDescription: Hashable, Codable {
    var title: String!
    var description: String
    var credit: String!
    var wikiPageId: String!
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
