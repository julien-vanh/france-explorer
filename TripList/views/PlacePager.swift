//
//  PlacePager.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlacePager: View {
    var placeDetailViews: [PlaceDetail]
    @State private var page: Int = 0
    
    init(places: [Place], place: Place){
        self.placeDetailViews = places.map { PlaceDetail(place: $0) }
        self.page = places.firstIndex(where: {$0.id == place.id}) ?? 0
    }
    
    init(places: [Place]){
        self.placeDetailViews = places.map { PlaceDetail(place: $0) }
        self.page = 0
    }

    var body: some View {
        PageView(placeDetailViews, currentPage: $page).edgesIgnoringSafeArea(.top)
    }
}

struct PlacePager_Previews: PreviewProvider {
    
    static var previews: some View {
        PlacePager(places: PlaceStore.shared.getRandom(count: 4))
    }
}
