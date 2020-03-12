//
//  PlaceViewCompact.swift
//  TripList
//
//  Created by Julien Vanheule on 22/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceViewCompact: View {
    var place: Place
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationLink(
            destination: PlaceDetail(place: place)
        ) {
            HStack(alignment: .bottom) {
                ImageStore.shared.image(forPlace: place)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height:70)
                    .clipped().cornerRadius(5)
                
                VStack(alignment: .leading) {
                    Text(place.title)
                        .font(.headline).lineLimit(2)
                    
                    HStack(alignment: .bottom, spacing: 10) {
                        Text(PlaceStore.shared.getCategory(placeCategory: place.category).title)
                            .foregroundColor(Color(AppStyle.color(for: place.category)))
                            .font(.caption)
                        
                        if locationManager.isLocationEnable() {
                            Text("à " + AppStyle.formatDistance(value: locationManager.distanceTo(coordinate: place.locationCoordinate)))
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                    SeparationBar()
                }
            }
            .frame(height: 70)
            .padding(.leading, 10.0)
        }
    }
}

struct PlaceViewCompact_Previews: PreviewProvider {
    static var previews: some View {
        PlaceViewCompact(place: PlaceStore.shared.getRandom(count: 1)[0])
    }
}
