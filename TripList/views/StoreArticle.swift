//
//  StoreArticle.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics

struct StoreArticle: View {
    var article: Article
    var associatedPlaces: [Place] = []
    
    init(article: Article){
        self.article = article
        associatedPlaces = article.places.map({ PlaceStore.shared.get(id: $0.placeId)})
    }
    
    var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                ImageStore.shared.image(name: "\(self.article.id).jpg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }.frame(height: 300)
            
            VStack {
                Text(self.article.content.title).font(.largeTitle)
                
                Text(self.article.content.description).padding()
                
                VStack(alignment: .leading) {
                    if associatedPlaces.count > 0 {
                        Text("Destinations associées")
                            .font(.title)
                            .padding([.top, .leading], 15)
                        
                        ForEach(associatedPlaces) { place in
                            HStack {
                                NavigationLink(
                                    destination: PlaceDetail(place: place)
                                ) {
                                    ImageStore.shared.image(forPlace: place)
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height:60)
                                        .clipped().cornerRadius(5)
                                }
                                
                                VStack {
                                    HStack {
                                        NavigationLink(
                                            destination: PlaceDetail(place: place)
                                        ) {
                                            Text(place.title)
                                        }
                                        
                                        Spacer()
                                        
                                        PlaceButtonsMini(place: place)
                                    }
                                    SeparationBar()
                                }
                                
                            }
                            .padding(.horizontal, 10.0)
                        }
                    }
                    
                }
                
                Rectangle().opacity(0).frame(height:40)
            }
        }.onAppear {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: self.article.id,
                AnalyticsParameterContentType: "article"
            ])
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
