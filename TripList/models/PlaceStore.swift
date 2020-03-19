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

final class PlaceStore: NSObject {
    typealias _PlaceDictionary = [String: Place]
    typealias _CategoryDictionary = [String: Category]
    fileprivate var premiumPlaces: _PlaceDictionary = [:] //all places included premium places
    fileprivate var freePlaces: _PlaceDictionary = [:] //free places only
    fileprivate var categories: _CategoryDictionary = [:]
    
    static let shared = PlaceStore()
    
    override init(){
        super.init()
        
        placesData.forEach { (place) in
            if !place.iap {
                freePlaces["\(place.id)"] = place
            }
            premiumPlaces["\(place.id)"] = place
        }
        
        categories[PlaceCategory.all.rawValue] = Category(id: 0, category: .all, title: "Tous", image: "")
        categories[PlaceCategory.city.rawValue] = Category(id: 1, category: .city, title: "Ville", image: "")
        categories[PlaceCategory.museum.rawValue] = Category(id: 2, category: .museum, title: "Musée", image: "")
        categories[PlaceCategory.nature.rawValue] = Category(id: 3, category: .nature, title: "Nature", image: "")
        categories[PlaceCategory.historical.rawValue] = Category(id: 4, category: .historical, title: "Histoire", image: "")
        categories[PlaceCategory.event.rawValue] = Category(id: 5, category: .event, title: "Sortie", image: "")
    }
    
    func get(id: String) -> Place! {
        if let index = premiumPlaces.index(forKey: id){
            return premiumPlaces.values[index]
        } else {
            return nil
        }
    }
    
    func getCategories() -> [Category] {
        return Array(categories.values)
    }
    
    func getCategory(placeCategory: PlaceCategory) -> Category {
        return categories[placeCategory.rawValue]!
    }
    
    func getRegions() -> [PlaceRegion] {
        return regionsData
    }
    
    func getPlacesFor(filter: FilterModel, premium: Bool, count: Int, position: CLLocation!) -> [Place]{
        let placeDict = premium ? premiumPlaces : freePlaces
        
        var result: [Place]
        if filter.categoryFilter != .all {
            result = placeDict.values.filter { $0.category == filter.categoryFilter }
        } else {
            result = Array(placeDict.values)
        }
        
        if filter.sortBy == .popularity {
            result.sort { (p1, p2) -> Bool in
                return p1.popularity > p2.popularity
            }
        } else if filter.sortBy == .distance && position != nil {
            let positionPoint = MKMapPoint(position.coordinate);
            
            result.sort { (p1, p2) -> Bool in
                let distanceP1 = positionPoint.distance(to: MKMapPoint(p1.locationCoordinate))
                let distanceP2 = positionPoint.distance(to: MKMapPoint(p2.locationCoordinate))
                return distanceP1 < distanceP2
            }
        }
        
        return Array(result.prefix(min(result.count, count)))
    }
    
    func getAllForRegion(regionId: String) -> [Place] {
        return premiumPlaces.values.filter { $0.regionId == regionId }
    }
    
    
    func getAllForSearch(search: String, premium: Bool) -> [Place] {
        let places = premium ? premiumPlaces : freePlaces
        
        if search.count > 2 {
            let hashSearch = search.lowercased().forSorting
            var matchingPlaces = places.values.filter { $0.hash.contains(hashSearch)}
            matchingPlaces.sort { (p1, p2) -> Bool in
                return p1.popularity > p2.popularity
            }
            return matchingPlaces
        } else {
            return []
        }
    }
    
    func getRandom(count:Int, premium: Bool) -> [Place] {
        let places = premium ? premiumPlaces : freePlaces
        return Array(places.values.shuffled().prefix(min(places.keys.count, count)))
    }
    
    func getAssociatedPlaceTo(place: Place, count: Int, premium: Bool) -> [Place]{
        return Array(getNearestPlaces(position: place.locationCoordinate, count: count+1, premium: premium).dropFirst()) //On retirer le premier car c'est le place à partir duquel on fait la recherche
    }
    
    func getAssociatedPlaceToArticle(article: Article) -> [Place]{
        let articlePlaces = article.places.sorted { (a1, a2) -> Bool in
            return a1.order < a2.order
        }
        return articlePlaces.compactMap({ PlaceStore.shared.get(id: $0.placeId)})
    }
    
    func getNearestPlaces(position: CLLocationCoordinate2D, count: Int, premium: Bool) -> [Place] {
        let places = premium ? premiumPlaces : freePlaces
        
        let positionPoint = MKMapPoint(position);
        
        let sortedPlaces = places.values.sorted { (p1, p2) -> Bool in
            let distanceP1 = positionPoint.distance(to: MKMapPoint(p1.locationCoordinate))
            let distanceP2 = positionPoint.distance(to: MKMapPoint(p2.locationCoordinate))
            return distanceP1 < distanceP2
        }
        return Array(sortedPlaces.prefix(min(sortedPlaces.count, count)))
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
