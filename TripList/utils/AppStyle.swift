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
            case .city: color = UIColor(hex: 0xE02020)
            case .museum: color = UIColor(hex: 0xFFA51C)
            case .nature: color = UIColor(hex: 0x3BCE41)
            case .historical: color = UIColor(hex: 0x7F7F7F)
            case .event: color = UIColor(hex: 0x2074E0)
            //case .park: color = UIColor(hex: 0x00796B)
            //case .activity: color = UIColor(hex: 0xE64A19)
        }
        return color
    }
    
    static func formatDistance(value: CLLocationDistance) -> String {
        let formatter = MKDistanceFormatter()
        return formatter.string(fromDistance: value)
       
    }
}

extension UIColor {
    static var mapOverlayUnexplored: UIColor {
        return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: CGFloat(0.0))
    }
    static var mapOverlayExploring: UIColor {
        return UIColor.init(red: 218/255, green: 185/255, blue: 57/255, alpha: CGFloat(1.0))
    }
    
    static var separationBar: UIColor {
        return UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: CGFloat(1))
    }
}


