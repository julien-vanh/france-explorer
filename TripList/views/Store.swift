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
                
                Carousel()
                
                RandomButton()
                
                NearestPlaces()
                
                StoreArticlesRow()
                
                StoreCategoriesRow()
                
                StoreSuggestions()
                
                Rectangle().opacity(0).frame(height:40)
                
            }.navigationBarTitle("Destinations")
        }.navigationViewStyle(StackNavigationViewStyle())
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
                ForEach(PlaceStore.shared.getRandom(count: self.CountInCarousel, withIllustration: true)) { place in
                    NavigationLink(
                        destination: PlaceDetail(place: place)
                    ) {
                        ImageStore.shared.image(forPlace: place)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width-20, height:geometry.size.height)
                            .clipped().cornerRadius(15).padding(10)
                    }
                }
            }
        }.frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
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

struct StoreSuggestions: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack
                {
                    Text("Suggestions")
                        .font(.title)
                    Spacer()
                    /*
                    Button(action: {
                        //
                    })
                    {
                        Text("Voir plus")
                    }*/
            }.padding(.horizontal, 10)
            
            PlaceGridCompact(places: PlaceStore.shared.getRandom(count: 9, withIllustration: true))
        }
    }
}
