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
            case .city: color = UIColor(hex: 0xD32F2F)
            case .museum: color = UIColor(hex: 0x616161)
            case .park: color = UIColor(hex: 0x00796B)
            case .activity: color = UIColor(hex: 0xE64A19)
            case .nature: color = UIColor(hex: 0x8BC34A)
            case .place: color = UIColor(hex: 0xFFA000)
            case .event: color = UIColor(hex: 0x1976D2)
        }
        return color
    }
}

extension UIColor {
    static var myAppRed: UIColor {
        return UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)
    }
    static var myAppGreen: UIColor {
        return UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    }
    static var myAppBlue: UIColor {
        return UIColor(red: 0, green: 0.2, blue: 0.9, alpha: 1)
    }
}


