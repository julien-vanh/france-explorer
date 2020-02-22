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
                            ImageStore.shared.image(forPlace: place)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height:60)
                                .clipped().cornerRadius(5)
                            
                            VStack(alignment: .leading) {
                                Text(place.title)
                                    .font(.headline)
                                Text(PlaceStore.shared.getCategory(placeCategory: place.category).title)
                                    .foregroundColor(Color(AppStyle.color(for: place.category)))
                                Spacer()
                                SeparationBar()
                            }
                            Spacer()
                        }
                        .padding(.leading, 10.0)
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
