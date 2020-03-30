//
//  NearestPlaces.swift
//  TripList
//
//  Created by Julien Vanheule on 11/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct NearestPlaces: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        VStack{
            if(locationManager.nearestPlaces != nil){
                HStack
                {
                    Text("À proximité")
                        .font(.title)
                    Spacer()
                    NavigationLink(destination: PlacesList(filter: FilterModel(sortBy: .distance, categoryFilter: .all))){
                        HStack {
                            Text("Voir plus")
                            Image(systemName: "chevron.right")
                        }.foregroundColor(.blue)
                    }
                }.padding(.horizontal)
                
                PlaceGridCompact(places: self.locationManager.nearestPlaces!)
            }
        }
    }
}

struct NearestPlaces_Previews: PreviewProvider {
    static var previews: some View {
        NearestPlaces()
    }
}
