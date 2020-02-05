//
//  Progression.swift
//  LifeList
//
//  Created by Julien Vanheule on 24/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import QGrid

struct Progression: View {
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(PlaceStore.shared.getRegions()) { region in
                    
                    Section(header: Text(region.name)) {
                        QGrid(PlaceStore.shared.getAllForRegion(regionId: region.id),
                          columns: 5,
                          columnsInLandscape: 10,
                          vSpacing: 0,
                          hSpacing: 0,
                          vPadding: 0,
                          hPadding: 0
                        ) { place in
                            NavigationLink(
                                destination: PlacePager(places: PlaceStore.shared.getAllForRegion(regionId: region.id), initialePlace: place)
                            ) {
                                ProgressionItem(place: place)
                            }
                        }
                        .frame(height: ceil(CGFloat(PlaceStore.shared.getAllForRegion(regionId: region.id).count) / 5.0)*70)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .navigationBarTitle("Progression")
        }//.accentColor( .white)
    }
}

struct Progression_Previews: PreviewProvider {
    static var previews: some View {
        Progression()
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
