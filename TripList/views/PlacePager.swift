//
//  PlacePager.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlacePager: View {
    var placeDetailViews: [UIHostingController<PlaceDetail>]
    @State private var currentPageIndex: Int
    
    init(places: [Place], initialePlace: Place){
        self.placeDetailViews = places.map { UIHostingController(rootView:PlaceDetail(place: $0, displayAssociates: false)) }
        _currentPageIndex = State(initialValue: places.firstIndex(where: {$0.id == initialePlace.id}) ?? 0)
    }
    
    var body: some View {
        PageViewController(currentPageIndex: $currentPageIndex, viewControllers: placeDetailViews)//.edgesIgnoringSafeArea(.top)
    }
}
