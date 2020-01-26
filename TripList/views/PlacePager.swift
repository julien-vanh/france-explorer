//
//  PlacePager.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlacePager: View {
    var places: [Place]
    @State private var page = 0

    var body: some View {
        VStack {
            
            Picker("Page", selection: $page) {
                Text("Page 1").tag(0)
                Text("Page 2").tag(1)
            }
 
            .pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            
            PageView([
                PlaceDetail(place: places[0]),
                PlaceDetail(place: places[1])
            ], currentPage: $page)
        }
    }
}

struct HintPager_Previews: PreviewProvider {
    static var previews: some View {
        PlacePager(places: PlaceStore.shared.getRandom(count: 4))
    }
}
