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
        ScrollView(.vertical) {
            ForEach(PlaceStore.shared.getCategories()) { category in
                
                HStack {
                    Text(category.title)
                        .font(.headline)
                        .foregroundColor(Color(AppStyle.color(for: category.category)))
                    Spacer()
                }.padding(.leading, 15)
                
                QGrid(PlaceStore.shared.getAllForCategory(category: category.category, regionId: self.region.id),
                      columns: 5,
                      columnsInLandscape: 10,
                      vSpacing: 5,
                      hSpacing: 5,
                      vPadding: 0,
                      hPadding: 5
                ) { place in
                    NavigationLink(
                            destination: PlacePager(places: PlaceStore.shared.getAllForCategory(category: category.category, regionId: self.region.id), initialePlace: place)
                        ) {
                            ProgressionItem(place: place)
                        }
                    }
                    .frame(height: ceil(CGFloat(PlaceStore.shared.getAllForCategory(category: category.category, regionId: self.region.id).count) / 5.0)*70)
                    .listRowInsets(EdgeInsets())
                
                SeparationBar().frame(height: 5)
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
    var place: Place
    var completed: Bool = true
    
    var body: some View {
        ZStack(alignment: .center) {
            ImageStore.shared.image(forPlace: place)
                .renderingMode(.original)
                .resizable()
                .grayscale(completed ? 0.7 : 0.0)
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70).clipped()
            
            if completed {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green).font(.title)
                    //.padding([.bottom, .trailing], 3.0)
            }
            
        }.frame(width: 70, height: 70)
    }
}
