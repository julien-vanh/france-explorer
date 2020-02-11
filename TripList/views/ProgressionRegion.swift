//
//  ProgressionRegion.swift
//  TripList
//
//  Created by Julien Vanheule on 08/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import QGrid

struct ProgressionRegion: View {
    var region: PlaceRegion
    
    var body: some View {
        List {
            ForEach(PlaceStore.shared.getCategories()) { category in
                
                Section(header: Text(category.title)) {
                    QGrid(PlaceStore.shared.getAllForCategory(category: category.category),
                      columns: 5,
                      columnsInLandscape: 10,
                      vSpacing: 0,
                      hSpacing: 0,
                      vPadding: 0,
                      hPadding: 0
                    ) { place in
                        NavigationLink(
                            destination: PlacePager(places: PlaceStore.shared.getAllForCategory(category: category.category), initialePlace: place)
                        ) {
                            ProgressionItem(place: place)
                        }
                    }
                    .frame(height: ceil(CGFloat(PlaceStore.shared.getAllForCategory(category: category.category).count) / 5.0)*70)
                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .navigationBarTitle(Text(region.name))
    }
}

struct ProgressionRegion_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionRegion(region: regionsData[0])
    }
}

struct ProgressionItem: View {
    @EnvironmentObject var session: Session
    var place: Place
    
    var body: some View {
        ImageStore.shared.image(name: place.id)
            .renderingMode(.original)
            .resizable()
            //.grayscale(self.session.isCompleted(placeId: place.id) ? 0.0 : 0.99)
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70).clipped()
    }
}
