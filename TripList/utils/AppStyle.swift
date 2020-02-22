//
//  AppStyle.swift
//  TripList
//
//  Created by Julien Vanheule on 31/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import UIKit

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
}

extension UIColor {
    static var mapOverlayUnexplored: UIColor {
        return UIColor.init(red: 244/255, green: 67/255, blue: 54/255, alpha: CGFloat(0.4))
    }
    static var mapOverlayExploring: UIColor {
        return UIColor.init(red: 255/255, green: 152/255, blue: 0/255, alpha: CGFloat(0.4))
    }
    static var mapOverlayExplored: UIColor {
        return UIColor.init(red: 76/255, green: 175/255, blue: 80/255, alpha: CGFloat(0.4))
    }
    
    static var separationBar: UIColor {
        return UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: CGFloat(1))
    }
}


