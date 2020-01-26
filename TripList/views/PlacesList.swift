//
//  HintList.swift
//  LifeList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlacesList: View {
    var category: Category!
    var places: [Place] = []
    
    init(){
        places = PlaceStore.shared.getRandom(count: 100)
    }
    
    init(category: Category){
        places = PlaceStore.shared.getAllForCategory(category: category.category)
    }
    
    var body: some View {
        List{
            ForEach(places) { place in
                NavigationLink(
                    destination: PlaceDetail(place: place)
                ) {
                    Text(place.title)
                }
            }
        }
    }
}

struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesList(category: Category(id: 2, category: .place, title: "Lieux", image: ""))
    }
}
