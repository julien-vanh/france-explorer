//
//  PlaceDetail.swift
//  TripList
//
//  Created by Julien Vanheule on 19/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit

struct PlaceDetail: View {
    @EnvironmentObject var session: Session
    var place: Place
    @State private var showCredits = false
    @State var wikiPage: WikiPage!
    
    
    init(){
        self.place = PlaceStore.shared.getRandom(count: 1)[0]
    }
    
    init(place: Place){
        self.place = place
    }

    var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                ImageStore.shared.image(name: self.place.id)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }.frame(height: 300)
            
            VStack {
                
                    
                NavigationLink(
                    destination: PlaceDetailPhotos(place: self.place)
                ) {
                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                        Text("photos")
                            .font(.headline)
                            .padding(.trailing, 15.0)
                    }
                    .foregroundColor(.white)
                }
                .padding(.top, -40.0)
                
                Text(self.place.title).font(.largeTitle)
                
                PlaceDetailsButtons(place: self.place)
                
                if self.place.description != nil {
                    Text(self.place.description).padding()
                } else if (self.wikiPage != nil && self.wikiPage != nil){
                    Text(self.wikiPage.extract).padding()
                }
                
                if self.place.website != nil {
                    HStack {
                        Text("Site web :")
                        Button(action: {
                            self.openLinkInBrowser(link: self.place.website)
                        }) {
                            Text(self.place.website).foregroundColor(.orange)
                        }
                    }
                    .padding(.vertical, 15.0)
                }
                
                MapView(coordinate: self.place.locationCoordinate)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(height: 200)
                
                AssociatesRow(placeId: self.place.id)
                    .padding(.bottom, 15.0)
                    
                Button(action: {
                    self.showCredits = true
                }) {
                    Text("Crédits").foregroundColor(.gray)
                }.sheet(isPresented: self.$showCredits) {
                    CreditsModal(place: self.place)
                }.padding(.bottom, 40.0)
            }
        }
        .edgesIgnoringSafeArea(.top).onAppear(perform: {
            print("hint loaded")
            if self.place.wikiPageId != nil {
                WikipediaService.shared.getPage(self.place.wikiPageId!) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let page):
                        self.wikiPage = page
                        print("page downloaded")
                    }
                }
            }
            
        }).onDisappear {
            print("hint disappear")
        }
    }
    
    private func openLinkInBrowser(link: String){
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
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

struct HintDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetail(place: placesData[2]).environmentObject(Session())
    }
}



struct CreditsModal: View {
    var place: Place
    
    var body: some View {
        VStack {
            Text("Crédits")
                .font(.title)
                .padding(.bottom, 50.0)
            if place.photocredits != nil {
                Text("Photo : ")
                Text("\(place.photocredits)").foregroundColor(.gray)
            }
            
            if place.source != nil {
                Text("Description : ")
                Text("\(place.source)").foregroundColor(.gray)
            }
        }
        
    }
}
