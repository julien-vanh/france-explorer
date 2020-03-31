//
//  DistanceView.swift
//  TripList
//
//  Created by Julien Vanheule on 19/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit


struct DistanceView: View {
    var coordinate: CLLocationCoordinate2D
    @ObservedObject private var locationManager = LocationManager.shared
    
    var body: some View {
        VStack {
            if self.locationManager.isLocationEnable() {
                Text("à \(AppStyle.formatDistance(value: self.locationManager.distanceTo(coordinate: coordinate)))")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(3)
                    .background(Color(.systemGray2))
                    .cornerRadius(10)
            }
        }
    }
}

struct DistanceViewFull: View {
    var coordinate: CLLocationCoordinate2D
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        VStack {
            if self.locationManager.isLocationEnable() {
                Text("à \(AppStyle.formatDistance(value: self.locationManager.distanceTo(coordinate: coordinate))) de ma position")
                    .padding(15)
                    .background(BlurView(style: .regular))
                    .cornerRadius(10)
            }
        }
    }
}
