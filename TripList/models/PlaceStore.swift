//
//  PlaceStore.swift
//  TripList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Combine
import SwiftUI

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
            Category(id: 1, category: .visit, title: "Visite", image: ""),
            Category(id: 2, category: .place, title: "Lieux", image: ""),
            Category(id: 3, category: .activity, title: "Activité", image: "")
        ]
    }
    
    func getRegions() -> [Region] {
        return  [
            Region(id: 1, region: .paris, title: "Paris", image: ""),
            Region(id: 2, region: .normandie, title: "Normandie", image: "")
        ]
    }
    
    func getAllForCategory(category: PlaceCategory) -> [Place] {
        return places.values.filter { $0.category == category }
    }
    
    func getAllForRegion(region: PlaceRegion) -> [Place] {
         return places.values.filter { $0.region == region }
    }
    
    func getRandom(count:Int) -> [Place] {
        var resultCount = 5
        if(count > places.keys.count){
            resultCount = places.keys.count
        }
        return Array(places.values.shuffled().prefix(resultCount))
    }
    
    func getAssociatedPlaceTo(id: String, count: Int) -> [Place]{
        //TODO
        return Array(places.values.shuffled().prefix(count))
    }
}

struct Region: Identifiable {
    var id: Int
    var region: PlaceRegion
    var title: String
    var image: String
    
    init(id: Int, region: PlaceRegion, title: String, image: String){
        self.id = id
        self.region = region
        self.title = title
        self.image = image
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
