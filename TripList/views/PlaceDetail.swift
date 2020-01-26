//
//  PlaceDetail.swift
//  TripList
//
//  Created by Julien Vanheule on 19/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit

struct PlaceDetail: View {
    @EnvironmentObject var session: Session
    var place: Place
    
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ImageStore.shared.image(name: "\(place.id)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250).clipped()
                
                Text(place.title).font(.largeTitle)
                
                Button(action: {
                    self.session.dreams.append(Dream(place: self.place))
                }) {
                    HStack{
                        Image(systemName: "plus")
                        Text("Ajouter à Ma Liste")
                            .font(.headline)
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(10)
                
                Text(place.description).padding()
                
                
                Button(action: {
                    self.openLinkInBrowser(link: self.place.source)
                }) {
                    Text(place.source).foregroundColor(.blue)
                }
                    
                MapView(coordinate: place.locationCoordinate)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(height: 300)
                
                AssociatesRow(associates: PlaceStore.shared.getAssociatedPlaceTo(id: place.id, count: 5))
                    .padding(.bottom, 50.0)
            }
            
        }.edgesIgnoringSafeArea(.top).onAppear(perform: {
            print("hint loaded")
        }).onDisappear {
            print("hint disappear")
        }
    }
    
    func openLinkInBrowser(link: String){
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}

struct HintDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetail(place: placesData[2]).environmentObject(Session())
    }
}
