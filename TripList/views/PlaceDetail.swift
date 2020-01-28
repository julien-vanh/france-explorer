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
    @State private var isComplete: Bool = false
    @State private var isInDream: Bool = false
    
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
                Text(self.place.title).font(.largeTitle)
                
                HStack {
                    Button(action: {
                        if self.session.isCompleted(placeId: self.place.id) {
                            self.session.setComplete(placeId: self.place.id, value: false)
                            self.isComplete = false
                        } else {
                            self.session.setComplete(placeId: self.place.id, value: true)
                            self.isComplete = true
                            self.session.dreams.removeAll(where: { self.place.id == $0.placeId }) // Si completer, on le retire auto des Dreams
                            self.isInDream = false
                        }
                    }) {
                        HStack {
                            Image(systemName: self.isComplete ? "checkmark.circle" : "circle")
                            Text("Déjà vu")
                                
                        }
                        .font(.headline)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    
                   
                    if (!self.isComplete) {
                        if self.isInDream {
                            Button(action: {
                                self.session.dreams.removeAll(where: { self.place.id == $0.placeId })
                                self.isInDream = false
                            }) {
                                Text("Retirer de Ma Liste")
                                    .font(.headline)
                            }
                            .padding()
                            .foregroundColor(.red)
                        } else {
                            HStack {
                                Button(action: {
                                    self.session.dreams.append(Dream(place: self.place))
                                    self.isInDream = true
                                }) {
                                    HStack{
                                        Image(systemName: "plus")
                                        Text("Ajouter à Ma Liste")
                                            .font(.headline)
                                    }
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.orange)
                                .cornerRadius(10)
                                
                                
                            }
                        }
                    }
                }
                
                
                
                
                Text(self.place.description).padding()
                
                Button(action: {
                    self.openLinkInBrowser(link: self.place.source)
                }) {
                    Text(self.place.source).foregroundColor(.blue)
                }
                    
                MapView(coordinate: self.place.locationCoordinate)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(height: 250)
                
                AssociatesRow(associates: PlaceStore.shared.getAssociatedPlaceTo(id: self.place.id, count: 5))
                    .padding(.bottom, 50.0)
            }
        }.edgesIgnoringSafeArea(.top).onAppear(perform: {
            print("hint loaded")
            self.isComplete = self.session.isCompleted(placeId: self.place.id)
            self.isInDream = self.session.isInDream(placeId: self.place.id)
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
