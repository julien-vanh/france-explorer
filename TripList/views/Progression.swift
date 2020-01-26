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
        NavigationView(){
            List{
                ForEach(PlaceStore.shared.getCategories()) { category in
                    
                    Section(header: Text(category.title)) {
                        QGrid(PlaceStore.shared.getAllForCategory(category: category.category),
                          columns: 6
                        ) { place in
                            NavigationLink(
                                destination: PlacePager(places: PlaceStore.shared.getRandom(count: 6))
                            ) {
                                Rond(place: place)
                            }
                        }
                        .frame(height: ceil(CGFloat(PlaceStore.shared.getAllForCategory(category: category.category).count) / 6.0)*50+30)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .navigationBarTitle("Progression")
        }
    }
}

struct Progression_Previews: PreviewProvider {
    static var previews: some View {
        Progression()
    }
}

struct Rond: View {
    var place: Place
    
    var body: some View {
        ImageStore.shared.image(name: "\(place.id)")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: 50.0, height: 50.0)
            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            
    }
}
