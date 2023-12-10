//
//  PlacePopularityStars.swift
//  TripList
//
//  Created by Julien Vanheule on 03/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlacePopularityStars: View {
    var place: Place
    var height: CGFloat
    
    var body: some View {
        HStack(spacing: 4){
            ForEach(1 ..< self.place.popularity, id: \.self){ _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Color(UIColor.explored))
                    .frame(width: self.height, height: self.height)
            }
        }
    }
}
