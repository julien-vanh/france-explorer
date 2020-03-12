//
//  PlaceAnnotationView.swift
//  TripList
//
//  Created by Julien Vanheule on 11/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit

enum PlaceAnnotationStyle {
    case Colored
    case Unexplored
    case Explored
    case PremiumLock
}

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var place: Place
    var style: PlaceAnnotationStyle
    
    init(place: Place, style: PlaceAnnotationStyle){
        self.place = place
        self.style = style
        self.coordinate = place.locationCoordinate
    }
}


internal final class PlaceAnnotationView: MKMarkerAnnotationView {
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        
        
        if annotation is PlaceAnnotation {
            let placeAnnotation = annotation as! PlaceAnnotation
            
            switch placeAnnotation.place.popularity{
            case 3:
                displayPriority = .required
            case 2:
                displayPriority = .defaultHigh
            default:
                displayPriority = .defaultLow
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented.")
    }
    
    func configure(with annotation: MKAnnotation) {
        guard annotation is PlaceAnnotation else { fatalError("Unexpected annotation type: \(annotation)") }
        let placeAnnotation = annotation as! PlaceAnnotation
        
        switch placeAnnotation.style {
        case .Explored:
            markerTintColor = UIColor.explored
            //glyphImage = UIImage(named: "\(placeAnnotation.place.category)-colored")
            glyphImage = UIImage(systemName: "checkmark.circle.fill")
        case .Colored:
            markerTintColor = AppStyle.color(for: placeAnnotation.place.category)
            glyphImage = UIImage(named: "\(placeAnnotation.place.category)-colored")
        case .PremiumLock:
            markerTintColor = UIColor.white
            glyphImage = UIImage(systemName: "questionmark")
            isEnabled = false
        default:
            markerTintColor = AppStyle.color(for: placeAnnotation.place.category)
            glyphImage = UIImage(named: "\(placeAnnotation.place.category)-colored")
            //glyphImage = UIImage(systemName: "questionmark")
        }
    }
}
