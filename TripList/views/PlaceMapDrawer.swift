//
//  PlacesMapDrawer.swift
//  TripList
//
//  Created by Julien Vanheule on 02/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit

struct PlaceMapDrawer: View {
    @Binding var place: Place
    @State private var showCredits = false
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(place.title)
                .font(.headline)
            
        
            HStack {
                Text(PlaceStore.shared.getCategory(placeCategory: self.place.category).title)
                    .foregroundColor(Color(AppStyle.color(for: self.place.category)))
                
                if locationManager.isLocationEnable() {
                    Text(" - " + AppStyle.formatDistance(value: locationManager.distanceTo(coordinate: place.locationCoordinate)))
                }
            }
            
            //PlaceButtons(place: place)
            
            
            GeometryReader { geometry in
                ImageStore.shared.image(forPlace: self.place)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height:geometry.size.height)
                    .clipped().cornerRadius(15).padding(10)
            }.frame(height: 150)
        
            
            
            if self.place.content != nil {
                Text(self.place.content!.description)
                    .lineLimit(6)
            }
            
            
            
            if self.place.address != nil {
                SeparationBar()
                Text("Adresse").foregroundColor(.gray).font(.subheadline)
                Button(action: {
                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.place.locationCoordinate, addressDictionary:nil))
                    mapItem.name = self.place.title
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                }) {
                    Text(self.place.address)
                }
            }
            
            if self.place.website != nil {
                SeparationBar()
                Text("Site web").foregroundColor(.gray).font(.subheadline)
                Button(action: {
                    AppState.openLinkInBrowser(link: self.place.website)
                }) {
                    Text(self.place.website).foregroundColor(.blue)
                }
            }
        
            SeparationBar()
            Button(action: {
                self.showCredits.toggle()
            }) {
                Text("Crédits").foregroundColor(.gray).font(.subheadline)
            }.sheet(isPresented: self.$showCredits) {
                CreditsModal(place: self.place)
            }
    
        }.padding()
    }
}

struct PlaceMapDrawer_Previews: PreviewProvider {
    static var previews: some View {
        PlaceMapDrawer(place: .constant(PlaceStore.shared.getRandom(count: 1)[0]))
    }
}
