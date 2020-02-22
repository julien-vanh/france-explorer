//
//  NearestPlaces.swift
//  TripList
//
//  Created by Julien Vanheule on 11/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct NearestPlaces: View {
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            if(locationManager.lastLocation != nil) {
                Text("À proximité")
                    .font(.title)
                    .padding([.top, .leading], 15)
                
                ForEach(PlaceStore.shared.getNearestPlaces(position: locationManager.lastLocation!.coordinate, count: 5)) { place in
                    NavigationLink(
                        destination: PlaceDetail(place: place)
                    ) {
                        PlaceViewCompact(place: place)
                    }
                }
            }
        }
    }
}

struct NearestPlaces_Previews: PreviewProvider {
    static var previews: some View {
        NearestPlaces()
    }
}
