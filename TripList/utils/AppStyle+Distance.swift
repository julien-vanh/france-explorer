//
//  AppStyle+Distance.swift
//  TripList
//
//  Created by Julien Vanheule on 21/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import MapKit

extension AppStyle {
    static func formatDistance(value: CLLocationDistance) -> String {
        let formatter = MKDistanceFormatter()
        return formatter.string(fromDistance: value)
       
    }
}
