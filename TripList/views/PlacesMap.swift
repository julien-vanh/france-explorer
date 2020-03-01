//
//  PlacesMap.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import Combine
import MapKit


struct PlacesMap: View {
    @ObservedObject var mapState: MapState
    var regionMap: RegionsMapController
    
    init(mapState: MapState){
        self.mapState = mapState
        self.regionMap = RegionsMapController(mapState: mapState)
    }
    
    var body: some View {
        
        ZStack(alignment: .topTrailing, content: {
            regionMap.edgesIgnoringSafeArea(.all)
            
            VStack {
                Button(action: {
                    self.regionMap.view.userTrackingMode = .follow
                }) {
                    Image(systemName: "location")
                        .font(.title)
                        
                }
                .frame(width: 40, height: 40, alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
                
                //Add other buttons here
            }
            .padding(.top, 50.0)
            .padding(.trailing, 4.0)
        })
        
    }
}

struct PlacesMap_Previews: PreviewProvider {
    static var previews: some View {
        PlacesMap(mapState: MapState())
    }
}
