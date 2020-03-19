//
//  AppStyle.swift
//  TripList
//
//  Created by Julien Vanheule on 31/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AppStyle {
    static func color(for placeCategory: PlaceCategory) -> UIColor {
        var color: UIColor
        switch placeCategory {
            case .city: color = UIColor(hex: 0x1DC0D1)
            case .museum: color = UIColor(hex: 0xF0652E)
            case .nature: color = UIColor(hex: 0x3BCE41)
            case .historical: color = UIColor(hex: 0x999999)
            case .event: color = UIColor(hex: 0x8C32C3)
            case .all: color = UIColor(hex: 0x333333)
        }
        return color
    }
    
    static func formatDistance(value: CLLocationDistance) -> String {
        let formatter = MKDistanceFormatter()
        return formatter.string(fromDistance: value)
       
    }
}

extension UIColor {
    static var unexplored: UIColor {
        return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: CGFloat(0.0))
    }
    static var explored: UIColor {
        return UIColor(hex: 0xFFC110)
    }
}


