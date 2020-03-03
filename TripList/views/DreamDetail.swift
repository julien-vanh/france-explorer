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
    @ObservedObject var locationManager = LocationManager.shared
    var dream: Dream
    var place: Place
    
    init(dream: Dream){
        self.dream = dream
        self.place = PlaceStore.shared.get(id: dream.placeId!)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                ImageStore.shared.image(forPlace: self.place)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }.frame(height: 300)
            
            VStack {
                
                Text(PlaceStore.shared.getCategory(placeCategory: self.place.category).title)
                    .foregroundColor(Color(AppStyle.color(for: self.place.category)))
                
                Text(self.place.title).font(.largeTitle)
                
                if locationManager.isLocationEnable() {
                    Text("à " + AppStyle.formatDistance(value: locationManager.distanceTo(coordinate: place.locationCoordinate)))
                }
                
                NavigationLink(destination: PlaceDetail(place: self.place, displayAssociates: false)) {
                    HStack {
                        Text("Détails sur la destination").foregroundColor(.blue)
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }
                .padding(.bottom)
                
                //TODO
                //Text("Hotels à proximité").font(.title)
                //Rectangle().background(Color.yellow).frame(width: 300, height: 150)
                
                if self.place.address != nil {
                    SeparationBar()
                    HStack {
                        Image(systemName: "map").frame(width: 30, height: 30, alignment: .center).font(.title)
                        Button(action: {
                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.place.locationCoordinate, addressDictionary:nil))
                            mapItem.name = self.place.title
                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                        }) {
                            Text(self.place.address)
                        }
                        Spacer()
                    }
                    .padding(.leading, 10.0)
                }
            }
            
            
            
            GeometryReader { geometry in
                MapView(place: self.place)
                    //.frame(width: geometry.size.width, height: UIScreen.main.bounds.height - 50 - self.getScrollOffset(geometry))//Lag
                    .frame(width: geometry.size.width, height: 500)
            }.frame(height: 500)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }
        return imageHeight
    }
}
