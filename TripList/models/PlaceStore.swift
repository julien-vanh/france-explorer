//
//  PlaceStore.swift
//  TripList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Combine
import SwiftUI
import CoreLocation
import MapKit

final class PlaceStore: ObservableObject {
    typealias _PlaceDictionary = [String: Place]
    fileprivate var places: _PlaceDictionary = [:]
    
    static let shared = PlaceStore()
    
    init(){
        placesData.forEach { places["\($0.id)"] = $0 }
    }
    
    func get(id: String) -> Place! {
        if let index = places.index(forKey: id){
            return places.values[index]
        } else {
            return nil
        }
    }
    
    func getCategories() -> [Category] {
        return  [
            Category(id: 1, category: .city, title: "Ville", image: ""),
            Category(id: 2, category: .museum, title: "Musée", image: ""),
            Category(id: 3, category: .park, title: "Parc", image: ""),
            Category(id: 4, category: .activity, title: "Activité", image: ""),
            Category(id: 5, category: .nature, title: "Nature", image: ""),
            Category(id: 6, category: .place, title: "Point d'intéret", image: ""),
            Category(id: 7, category: .event, title: "Evenement", image: "")
        ]
    }
    
    func getRegions() -> [PlaceRegion] {
        return regionsData
    }
    
    func getAllForCategory(category: PlaceCategory) -> [Place] {
        return places.values.filter { $0.category == category }
    }
    
    func getAllForRegion(regionId: String) -> [Place] {
        return places.values.filter { $0.regionId == regionId }
    }
    
    func getRandom(count:Int) -> [Place] {
        var resultCount: Int
        if(count > places.keys.count){
            resultCount = places.keys.count
        } else {
            resultCount = count
        }
        return Array(places.values.shuffled().prefix(resultCount))
    }
    
    func getAssociatedPlaceTo(id: String, count: Int) -> [Place]{
        if let place = get(id: id) {
            return Array(getNearestPlaces(position: place.locationCoordinate, count: 8).dropFirst()) //On retirer le premier car c'est le place à partir duquel on fait la recherche
        } else {
            return Array(places.values.shuffled().prefix(count))
        }
        
    }
    
    func getNearestPlaces(position: CLLocationCoordinate2D, count: Int) -> [Place] {
        var resultCount: Int
        if(count > places.keys.count){
            resultCount = places.keys.count
        } else {
            resultCount = count
        }
        let positionPoint = MKMapPoint(position);
        
        let sortedPlaces = places.values.sorted { (p1, p2) -> Bool in
            let distanceP1 = positionPoint.distance(to: MKMapPoint(p1.locationCoordinate))
            let distanceP2 = positionPoint.distance(to: MKMapPoint(p2.locationCoordinate))
            return distanceP1 < distanceP2
        }
        return Array(sortedPlaces.prefix(resultCount))
    }
}

struct Category: Identifiable {
    var id: Int
    var category: PlaceCategory
    var title: String
    var image: String
    
    init(id: Int, category: PlaceCategory, title: String, image: String){
        self.id = id
        self.category = category
        self.title = title
        self.image = image
    }
}
