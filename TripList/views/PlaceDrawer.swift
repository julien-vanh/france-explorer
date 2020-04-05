//
//  PlacesMapDrawer.swift
//  TripList
//
//  Created by Julien Vanheule on 02/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit
import QGrid

struct PlaceDrawer: View {
    var place: Place
    @State private var showCredits = false
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(place.titleLocalized)
                .font(.title)
                .padding(.top, 24)
                .padding(.trailing, 45)
                .padding(.bottom, 10)
            
        
            HStack(alignment: .center, spacing: 10) {
                Text(PlaceStore.shared.getCategory(placeCategory: self.place.category).title)
                    .foregroundColor(Color(AppStyle.color(for: self.place.category)))
                
                PlacePopularityStars(place: self.place, height: 15)
                
                DistanceView(coordinate: self.place.locationCoordinate)
            }
            
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                PlaceButtons(place: place)
                
                HStack(alignment: .top, spacing: 10) {
                    ImageStore.shared.image(forPlace: self.place)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:150)
                        .clipped().cornerRadius(15)
                        
                    Spacer()
                    
                    PlaceDrawerMetadata(place: place)
                }
            } else {
                HStack{
                    Spacer()
                    ImageStore.shared.image(forPlace: self.place)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:150)
                        .clipped().cornerRadius(15)
                    Spacer()
                }
                
                PlaceButtons(place: place)
                    
                PlaceDrawerMetadata(place: place)
            }
            
            if self.place.descriptionLocalized != nil {
                SeparationBar()
                ScrollView {
                    Text(self.place.descriptionLocalized!.content)
                }
                
            }
            
            SeparationBar()
            
            Button(action: {
                self.showCredits.toggle()
            }) {
                Image(systemName: "c.circle")
            }.padding(.trailing, 10.0)
        }
        .padding()
        .sheet(isPresented: self.$showCredits) {
            CreditsModal(place: self.place)
        }
    }
}

struct PlaceMapDrawer_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDrawer(place: PlaceStore.shared.getRandom(count: 1, premium: false)[0])
    }
}

struct PlaceDrawerMetadata: View {
    var place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.place.address != nil {
                SeparationBar()
                Text("Adresse").foregroundColor(.gray).font(.subheadline)
                Button(action: {
                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.place.locationCoordinate, addressDictionary:nil))
                    mapItem.name = self.place.titleLocalized
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                }) {
                    Text(self.place.address)
                }
            }
            
            if self.place.website != nil {
                SeparationBar()
                Text("Site web").foregroundColor(.gray).font(.subheadline)
                Button(action: {
                    Browser.openLinkInBrowser(link: self.place.website)
                }) {
                    Text(self.place.website).foregroundColor(.blue)
                }
            }
        }
    }
}
