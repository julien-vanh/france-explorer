//
//  AssociatedHintsRow.swift
//  LifeList
//
//  Created by Julien Vanheule on 24/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct AssociatesRow: View {
    var associates: [Place]
    
    var body: some View {
       VStack(alignment: .leading) {
            Text("Découvrez aussi")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(associates) { place in
                        NavigationLink(
                            destination: PlaceDetail(
                                place: place
                            )
                        ) {
                            ZStack {
                                ImageStore.shared.image(name: place.id)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped().frame(width: 155, height: 155)
                                
                                Text(place.title)
                                    .fontWeight(.semibold)
                                    .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                                    .foregroundColor(.white).frame(width: 155, height: 155)
                            }
                            .cornerRadius(5)
                            .padding(.leading, 15)
                        }
                    }
                }
            }
            .frame(height: 155)
        }
    }
}

struct AssociatedHintsRow_Previews: PreviewProvider {
    static var previews: some View {
        AssociatesRow(associates: PlaceStore.shared.getRandom(count: 3))
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
