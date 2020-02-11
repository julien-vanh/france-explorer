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
                        HStack {
                            ImageStore.shared.image(name: place.id)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height:60)
                                .clipped().cornerRadius(5)
                            Text(place.title)
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.leading, 15.0)
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
