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
    @State var websitePresented = false
    @State var place: Place = PlaceStore.shared.getRandom(count: 1, premium: false)[0]
    var displayAssociates: Bool = true
    @State private var showCredits = false
   

    var body: some View {
        
        ScrollView(.vertical) {
            
            GeometryReader { geometry in
                ZStack {
                    ImageStore.shared.image(forPlace: self.place)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                    .navigationBarTitle(self.getNavigationTitle(geometry))
                    
                    //LinearGradient(gradient: Gradient(colors: [.clear, Color.black.opacity(0.4)]), startPoint: .center, endPoint: .bottom)
                    //    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    //    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                }
                
            }.frame(height: 400)
            
            
            VStack(spacing: 10) {
                VStack(alignment: .center, spacing: 5) {
                    Spacer()
                    
                    if(place.popularity > 1){
                        PlacePopularityStars(place: place, height: 30)
                    }
                    
                    Text(self.place.titleLocalized).font(.largeTitle)
                        .fontWeight(.semibold)
                        .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                    
                    
                    
                }.frame(height: 300).padding(.top, -310)
                
                ZStack{
                    
                    Text(PlaceStore.shared.getCategory(placeCategory: self.place.category).title)
                    .foregroundColor(Color(AppStyle.color(for: self.place.category)))
                    
                    HStack {
                        NavigationLink(
                            destination: PlaceDetailPhotos(place: self.place)
                        ) {
                            HStack {
                                Image(systemName: "photo")
                                Text("Photos")
                            }
                        }
                        .padding(.leading, 10.0)
                        
                        Spacer()
                        
                        Button(action: {
                            self.showCredits.toggle()
                        }) {
                            Image(systemName: "c.circle")
                        }.padding(.trailing, 10.0).sheet(isPresented: self.$showCredits) {
                            CreditsModal(place: self.place)
                        }
                    }
                }.padding(.bottom)
                
                PlaceButtons(place: self.place)
                
                if self.place.descriptionLocalized != nil {
                    VStack {
                        Text(self.place.descriptionLocalized!.content)
                            .padding( 10.0)
                    }
                    
                }
                
                if self.place.address != nil {
                    SeparationBar()
                    HStack {
                        Image(systemName: "location").frame(width: 30, height: 30, alignment: .center)
                            .font(.title)
                            .padding(.trailing, 10)
                        Button(action: {
                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.place.locationCoordinate, addressDictionary:nil))
                            mapItem.name = self.place.titleLocalized
                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                        }) {
                            Text(self.place.address)
                        }
                        Spacer()
                    }
                    .padding(.leading, 10.0)
                }
                
                if self.place.website != nil {
                    SeparationBar()
                    HStack {
                        Image(systemName: "globe").frame(width: 30, height: 30, alignment: .center)
                            .font(.title)
                            .padding(.trailing, 10)
                        
                        Button(action: {self.websitePresented.toggle()}) {
                            Text("Site web")
                        }.sheet(isPresented: self.$websitePresented, content: {
                            WebViewModal(title: self.place.titleLocalized, url: self.place.website)
                        })
                        Spacer()
                    }
                    .padding(.leading, 10.0)
                }
                
                /*
                if false {
                    SeparationBar()
                    AssociatesActivities(place: self.place)
                        
                }
                
                if false {
                    SeparationBar()
                    AssociatesHotels(place: self.place)
                        
                }
                */
                
                
                if displayAssociates {
                    SeparationBar()
                    AssociatesRow(place: self.$place)
                        .padding(.top, 10.0)
                        .padding(.bottom, 15.0)
                }
                
            }
            
            ZStack(alignment: .top) {
                GeometryReader { geometry in
                    PlaceMapView(place: self.place)
                        //.frame(width: geometry.size.width, height: UIScreen.main.bounds.height - 50 - self.getScrollOffset(geometry)).disabled(true)//Lag
                        .frame(width: geometry.size.width, height: 500).disabled(true)
            
                }.frame(height: 500)
                
                DistanceViewFull(coordinate: self.place.locationCoordinate).padding(10)
            }
                
        }
        .edgesIgnoringSafeArea(.top)
        
    }
    
    private func getNavigationTitle(_ geometry: GeometryProxy) -> String {
        return getScrollOffset(geometry) < -300 ? self.place.titleLocalized : ""
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.frame(in: .global).minY
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

struct PlaceDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetail(place: placesData[2])
    }
}




