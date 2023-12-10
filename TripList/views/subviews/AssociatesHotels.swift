//
//  AssociatesHotels.swift
//  TripList
//
//  Created by Julien Vanheule on 10/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct AssociatesHotels: View {
    var place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
                Text("Hôtels à proximité")
                    .font(.headline)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(1..<5) { _ in
                            
                            //NavigationLink(destination: PlaceDetail(place: place, displayAssociates: false )){
                            VStack(alignment: .leading, spacing: 0) {
                                ImageStore.shared.localImage(name: "hotelroom.jpg")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 155, height: 100)
                                    .cornerRadius(10)
                                Text("Auberge du Lion D'Or").font(.footnote)
                                
                                HStack {
                                    Text("45 €").font(.caption)
                                    Spacer()
                                    Text("★★★★★").foregroundColor(.yellow)
                                }
                                
                                Text("Détails").font(.callout)
                                    .foregroundColor(.white)
                                    .padding(2)
                                    .frame(width: 155)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    
                            }
                            .padding(.leading, 15)
                        //}
                        }
                    }
                }
                //.frame(height: 155)
            }
        }
}

struct AssociatesHotels_Previews: PreviewProvider {
    static var previews: some View {
        AssociatesHotels(place: PlaceStore.shared.getRandom(count: 1, premium: true)[0])
    }
}
