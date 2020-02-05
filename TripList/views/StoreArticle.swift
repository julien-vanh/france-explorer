//
//  StoreArticle.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct StoreArticle: View {
    var article: Article
    var associatedPlaces: [Place] = []
    
    init(article: Article){
        self.article = article
        associatedPlaces = article.places.map({ PlaceStore.shared.get(id: $0)})
    }
    
    var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                ImageStore.shared.image(name: "article\(self.article.id)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }.frame(height: 300)
            
            VStack {
                Text(self.article.title).font(.largeTitle)
                
                Text(self.article.description).padding()
                
                VStack(alignment: .leading) {
                    Text("Destinations associées")
                        .font(.title)
                        .padding([.top, .leading], 15)
                    
                    ForEach(associatedPlaces) { place in
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
                /*
                AssociatesRow(placeId: self.place.id)
                    .padding(.bottom, 15.0)
                
                Button(action: {
                    self.showCredits = true
                }) {
                    Text("Crédits").foregroundColor(.gray)
                }.sheet(isPresented: self.$showCredits) {
                    CreditsModal(place: self.article)
                }.padding(.bottom, 40.0)
                */
            }
        }
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }
        return imageHeight
    }
}

struct StoreArticle_Previews: PreviewProvider {
    static var previews: some View {
        StoreArticle(article: articlesData[0])
    }
}
