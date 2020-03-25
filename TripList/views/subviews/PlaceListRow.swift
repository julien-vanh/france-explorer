//
//  PlaceListRow.swift
//  TripList
//
//  Created by Julien Vanheule on 19/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceListRow: View {
    var place: Place
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image("\(place.category)-colored")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .padding(8)
            
            Text(place.titleLocalized)
            
            Spacer()
            
            DistanceView(coordinate: place.locationCoordinate)
        }
    }
}

struct PlaceListRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListRow(place: PlaceStore.shared.getRandom(count: 1, premium: false)[0])
            .previewLayout(.fixed(width: 320, height: 50))
    }
}
