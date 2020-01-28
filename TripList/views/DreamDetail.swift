//
//  DreamDetail.swift
//  TripList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit
import UIKit

struct DreamDetail: View {
    var dream: Dream
    var place: Place
    
    init(dream: Dream){
        self.dream = dream
        self.place = PlaceStore.shared.get(id: dream.placeId)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ImageStore.shared.image(name: place.id)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                
                Text(place.title).font(.largeTitle)
                
                
                HStack{
                    Image(systemName: "house.fill")
                    Text("Réserver un hotel")
                }
                HStack{
                    Image(systemName: "car.fill")
                    Text("Louer une voiture")
                }
                
                
                
                ZStack {
                    MapView(coordinate: place.locationCoordinate)
                        .edgesIgnoringSafeArea(.bottom)
                        .frame(height: 200)
                        .disabled(true)
                        .overlay(
                            Button(action: {
                                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.place.locationCoordinate, addressDictionary:nil))
                                mapItem.name = self.place.title
                                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                            }) {
                                HStack{
                                    Image(systemName: "location.circle")
                                    Text("Y aller")
                                        .font(.headline)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                            .padding([.top, .trailing], 10.0), alignment: .center)
                    
                }
                
 
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct DreamDetail_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetail(dream: Dream(place: PlaceStore.shared.get(id: "2")))
    }
}
