//
//  Place.swift
//  TripList
//
//  Created by Julien Vanheule on 19/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import CoreLocation

struct Place: Decodable, Identifiable {
    var id: String
    fileprivate var title: TranslatableField<String>
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
    var illustration: Illustration!
    fileprivate var description: TranslatableField<PlaceDescription>
    var wikiPageId: Int!
    var cta: CallToAction!
    
    var hash: String {
        var hash = titleLocalized + regionId
        if let contentdefined = address {
            hash += contentdefined
        }
        return hash.lowercased().forSorting
    }
    
    var titleLocalized: String {
        var output: String = ""
        if( Locale.current.languageCode == "fr"){
            if let res = title.fr {
                output = res
            }
        } else {
            if let res = title.en {
                output = res
            } else if let res = title.fr { //fallback en FR
                output = res
            }
        }
        /*
        if popularity == 3 {
            output = output + "\n★★"
        }
        if popularity == 2 {
            output = output + "\n★"
        }
 */
        return output
    }
    
    var descriptionLocalized: PlaceDescription! {
        if( Locale.current.languageCode == "fr"){
            if let res = description.fr {
                return res
            }
        } else {
            if let res = description.en {
                return res
            }
        }
        return nil
    }
}

extension String {
    var forSorting: String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
    }
}

struct Illustration: Hashable, Codable {
    var path: String
    var description: String
    var credit: String
    var source: String
}

struct PlaceDescription: Decodable {
    var content: String
    var credit: String
}

struct PlaceRegion: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var domtom: Bool
}

enum PlaceCategory: String, CaseIterable, Codable, Hashable {
    case all = "all"
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
