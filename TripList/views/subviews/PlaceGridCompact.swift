//
//  PlaceGridCompact.swift
//  TripList
//
//  Created by Julien Vanheule on 23/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceGridCompact: View {
    var places: [Place]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach((0...2), id: \.self) { col in
                    VStack {
                        ForEach((0...2), id: \.self) { row in
                            PlaceViewCompact(place: self.places[col*3+row])
                                .frame(width: 325)
                        }
                    }
                }
                Rectangle().opacity(0).frame(width:50)
            }
        }
    }
}

struct PlaceGridCompact_Previews: PreviewProvider {
    static var previews: some View {
        PlaceGridCompact(places: PlaceStore.shared.getRandom(count: 9))
    }
}
