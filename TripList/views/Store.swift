//
//  Store.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct Store: View {
    let CountInCarousel = 3
    
    var body: some View {
        NavigationView {
            List {
                Text("Découvrez des centaines d'idées pour remplir votre Liste...")
                
                GeometryReader { geometry in
                    ImageCarouselView(numberOfImages: self.CountInCarousel) {
                        ForEach(PlaceStore.shared.getRandom(count: self.CountInCarousel)) { place in
                            NavigationLink(
                                destination: PlaceDetail(place: place)
                            ) {
                                ImageStore.shared.image(name: place.id)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height:geometry.size.height)
                                    .clipped()
                            }
                            
                        }
                    }
                }.frame(height: 200, alignment: .center).listRowInsets(EdgeInsets())
                
                VStack(alignment: .center) {
                    HStack {
                        Image(systemName: "shuffle")
                            .font(.headline)
                        Text("Au hasard")
                            .fontWeight(.semibold)
                            .font(.headline).foregroundColor(.white)
                    }
                    
                    .frame(width: 250.0, height: 40.0)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                    
                    NavigationLink(destination: PlaceDetail(place: PlaceStore.shared.getRandom(count: 1)[0])) {
                        EmptyView()
                    }
                }.padding(.bottom, -15.0)
                
                StoreCategoriesRow().listRowInsets(EdgeInsets())
                
                Group {
                    Text("Suggestions")
                        .font(.headline)
                        .padding(.top, 5)
                    
                    ForEach(PlaceStore.shared.getRandom(count: 5)) { place in
                        NavigationLink(
                            destination: PlaceDetail(place: place)
                        ) {
                            Text(place.title)
                        }
                    }
                    NavigationLink(destination: PlacesList()) {
                        Text("Voir tout")
                    }
                }
                
            }.navigationBarTitle("Idées")
        }.accentColor( .white)
    }
}

struct Store_Previews: PreviewProvider {
    static var previews: some View {
        Store()
    }
}
