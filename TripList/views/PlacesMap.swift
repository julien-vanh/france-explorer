//
//  PlacesMap.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import Combine



struct PlacesMap: View {
    @ObservedObject var mapState: MapState
    
    var body: some View {
        GeometryReader { geometry in
            RegionsMapController(mapState: self.mapState)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct PlacesMap_Previews: PreviewProvider {
    static var previews: some View {
        PlacesMap(mapState: MapState())
    }
}
