//
//  StoreArticle.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics

struct ArticleDetail: View {
    var article: Article
    var associatedPlaces: [Place] = []
    @ObservedObject var appState = AppState.shared
    
    init(article: Article){
        self.article = article
        associatedPlaces = PlaceStore.shared.getAssociatedPlaceToArticle(article: article)
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
                    .navigationBarTitle(self.getNavigationTitle(geometry))
            }.frame(height: 300)
            
            VStack {
                Text(self.article.titleLocalized).font(.largeTitle)
                
                Text(self.article.descriptionLocalized).padding(10)
                
                SeparationBar()
                
                VStack(alignment: .leading) {
                    if associatedPlaces.count > 0 {
                        Text("Destinations associées")
                            .font(.headline)
                            .padding([.top, .leading], 15)
                        
                        ForEach(associatedPlaces) { place in
                            if place.iap && !self.appState.isPremium {
                                ArticleAssociatedPlaceLocked(place: place)
                            } else {
                                ArticleAssociatedPlace(place: place)
                            }
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
    private func getNavigationTitle(_ geometry: GeometryProxy) -> String {
        return getScrollOffset(geometry) < -250 ? self.article.titleLocalized : ""
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

/*
struct StoreArticle_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetail(article: articlesData[0])
    }
}
*/

struct ArticleAssociatedPlace: View {
    var place: Place
    
    var body: some View {
        HStack(alignment: .bottom) {
            NavigationLink(
                destination: PlaceDetail(place: place)
            ) {
                ImageStore.shared.image(forPlace: place)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height:70)
                    .clipped().cornerRadius(5)
            }
            
            VStack(alignment: .leading){
                HStack(alignment: .center) {
                    NavigationLink(
                        destination: PlaceDetail(place: place)
                    ) {
                        Text(place.titleLocalized).font(.headline).lineLimit(2)
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        PlaceButtonsMini(place: place)
                        Spacer()
                    }
                }
                Spacer()
                SeparationBar()
            }
            
            
            
        }
        .frame(height: 70)
        .padding(.horizontal, 10.0)
    }
}

struct ArticleAssociatedPlaceLocked: View {
    var place: Place
    @ObservedObject private var appState = AppState.shared
    
    var body: some View {
        Button(action: {
            self.appState.displayPurchasePageDrawer()
        }) {
            HStack(alignment: .bottom) {
                ImageStore.shared.image(forPlace: place)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height:70)
                    .clipped().blur(radius: 5).cornerRadius(5)
                
                VStack(alignment: .leading) {
                    Spacer()
                    Text(place.titleLocalized).font(.headline).lineLimit(2).blur(radius: 5)
                    Spacer()
                    SeparationBar()
                }
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 10.0)
    }
}

struct ArticleAssociatedPlace_Previews: PreviewProvider {
    static var previews: some View {
        ArticleAssociatedPlace(place: PlaceStore.shared.getRandom(count: 1, premium: false)[0])
    }
}
