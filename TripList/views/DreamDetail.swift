//
//  DreamDetail.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit

struct DreamDetail: View {
    var dream: Dream
    var place: Place
    
    init(dream: Dream){
        self.dream = dream
        self.place = PlaceStore.shared.get(id: dream.placeId)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ImageStore.shared.image(name: place.id)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                
                Text(place.title).font(.largeTitle)
                
                Text(dream.note).padding()
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct DreamDetail_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetail(dream: Dream(place: PlaceStore.shared.get(id: "2")))
    }
}
