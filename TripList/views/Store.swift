//
//  Store.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct Store: View {

    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {
                Text("Découvrez des centaines d'idées pour remplir votre Liste...")
                    .padding(.leading, 15.0)
                
                Carousel()
                
                NearestPlaces()
                
                RandomButton()
                
                StoreArticlesRow()
                
                StoreCategoriesRow()
                
                VStack(alignment: .leading) {
                    Text("Suggestions")
                        .font(.title)
                        .padding([.top, .leading], 15)
                    
                    ForEach(PlaceStore.shared.getRandom(count: 5)) { place in
                        NavigationLink(
                            destination: PlaceDetail(place: place)
                        ) {
                            HStack {
                                ImageStore.shared.image(name: place.id)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height:60)
                                    .clipped().cornerRadius(5)
                                Text(place.title)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.leading, 15.0)
                        }
                    }
                }
                
                Rectangle().opacity(0).frame(height:40)
                
            }.navigationBarTitle("Idées")
        }
    }
}

struct Store_Previews: PreviewProvider {
    static var previews: some View {
        Store()
    }
}

struct Carousel: View {
    let CountInCarousel = 5
    
    var body: some View {
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
        }.frame(width: UIScreen.main.bounds.width, height: 200, alignment: .center)
    }
}

struct RandomButton: View {
    var body: some View {
        VStack(alignment: .center) {
            NavigationLink(destination: LazyView(PlaceDetail())) {
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
            }
        }
    }
}
