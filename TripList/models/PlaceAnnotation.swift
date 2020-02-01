//
//  PlaceAnnotation.swift
//  TripList
//
//  Created by Julien Vanheule on 31/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var place: Place
    var completed: Bool
    
    init(place: Place, completed: Bool){
        self.place = place
        self.coordinate = place.locationCoordinate
        self.completed = completed
    }
}
