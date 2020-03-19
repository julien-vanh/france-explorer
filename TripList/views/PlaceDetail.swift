//
//  PlaceDetail.swift
//  TripList
//
//  Created by Julien Vanheule on 19/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MapKit
import FirebaseAnalytics

struct PlaceDetail: View {
    @State var websitePresented = false
    @State var place: Place = PlaceStore.shared.getRandom(count: 1, premium: false)[0]
    var displayAssociates: Bool = true
    @State private var showCredits = false
   

    var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                ImageStore.shared.image(forPlace: self.place)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                    .navigationBarTitle(self.getNavigationTitle(geometry))
            }.frame(height: 400)
            
            
            VStack {
                
                HStack{
                    NavigationLink(
                        destination: PlaceDetailPhotos(place: self.place)
                    ) {
                        HStack {
                            Image(systemName: "photo")
                            Text("photos")
                        }

                    }
                    .foregroundColor(.blue)
                    .padding(5.0)
                    .background(BlurView())
                    .cornerRadius(10)
                        
                    Spacer()
                }
                .padding(.leading, 10.0)
                .padding(.top, -45.0)
                
                Text(PlaceStore.shared.getCategory(placeCategory: self.place.category).title)
                    .foregroundColor(Color(AppStyle.color(for: self.place.category)))
                
                Text(self.place.title).font(.largeTitle).multilineTextAlignment(.center)
                
                DistanceView(coordinate: place.locationCoordinate)
                
                
                PlaceButtons(place: self.place)
                
                
                if self.place.content != nil {
                    Text(self.place.content!.description)
                        .padding( 10.0)
                }
                
                if self.place.address != nil {
                    SeparationBar()
                    HStack {
                        Image(systemName: "location").frame(width: 30, height: 30, alignment: .center)
                            .font(.title)
                            .padding(.trailing, 10)
                        Button(action: {
                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: self.place.locationCoordinate, addressDictionary:nil))
                            mapItem.name = self.place.title
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
                            WebViewModal(title: self.place.title, url: self.place.website)
                        })
                        Spacer()
                    }
                    .padding(.leading, 10.0)
                }
                
                
                if displayAssociates {
                    AssociatesRow(place: self.$place)
                        .padding(.top, 10.0)
                        .padding(.bottom, 15.0)
                }
                
                Button(action: {
                    self.showCredits.toggle()
                }) {
                    Text("Crédits").foregroundColor(.gray)
                }.sheet(isPresented: self.$showCredits) {
                    CreditsModal(place: self.place)
                }
            }
            
            
            
            GeometryReader { geometry in
                PlaceMapView(place: self.place)
                    //.frame(width: geometry.size.width, height: UIScreen.main.bounds.height - 50 - self.getScrollOffset(geometry)).disabled(true)//Lag
                    .frame(width: geometry.size.width, height: 500).disabled(true)
            }.frame(height: 500)
        }.onAppear {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: self.place.id,
                AnalyticsParameterContentType: "place"
            ])
        }
        .edgesIgnoringSafeArea(.top)
        
    }
    
    private func getNavigationTitle(_ geometry: GeometryProxy) -> String {
        return getScrollOffset(geometry) < -390 ? self.place.title : ""
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

struct HintDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetail(place: placesData[2])
    }
}



struct CreditsModal: View {
    var place: Place
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
                if place.illustration != nil {
                    Text("Photo")
                    Text(place.illustration!.description).foregroundColor(.gray)
                    Text(place.illustration!.credit).foregroundColor(.gray)
                    Text(place.illustration!.source).foregroundColor(.gray)
                    .padding(.bottom, 30.0)
                }
                
                if (self.place.content != nil){
                    Text("Texte")
                    Text(self.place.content!.credit).foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Crédits", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("OK") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.environment(\.horizontalSizeClass, .compact)
        
    }
}
