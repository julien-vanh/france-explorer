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
    @EnvironmentObject var session: Session
    
    var body: some View {
        NavigationView {
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
                                destination: PlacePager(places: PlaceStore.shared.getAllForCategory(category: category.category), place: place)
                            ) {
                                
                                    ImageStore.shared.image(name: place.id)
                                        .renderingMode(.original)
                                        .resizable()
                                        .grayscale(self.session.isCompleted(placeId: place.id) ? 0.0 : 0.99)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 70, height: 70).clipped()
                                
                            }
                        }
                        .frame(height: ceil(CGFloat(PlaceStore.shared.getAllForCategory(category: category.category).count) / 6.0)*50+20)
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


