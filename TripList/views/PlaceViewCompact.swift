//
//  PlaceViewCompact.swift
//  TripList
//
//  Created by Julien Vanheule on 22/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceViewCompact: View {
    var place: Place
    
    var body: some View {
        NavigationLink(
            destination: PlaceDetail(place: place)
        ) {
            HStack {
                ImageStore.shared.image(forPlace: place)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height:60)
                    .clipped().cornerRadius(5)
                
                VStack(alignment: .leading) {
                    Text(place.title)
                        .font(.headline)
                    Text(PlaceStore.shared.getCategory(placeCategory: place.category).title)
                        .foregroundColor(Color(AppStyle.color(for: place.category)))
                    Spacer()
                    SeparationBar()
                }
                Spacer()
            }
            .padding(.leading, 10.0)
        }
    }
}

struct PlaceViewCompact_Previews: PreviewProvider {
    static var previews: some View {
        PlaceViewCompact(place: PlaceStore.shared.getRandom(count: 1)[0])
    }
}
