//
//  PlacesMapDrawer.swift
//  TripList
//
//  Created by Julien Vanheule on 02/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceMapDrawer: View {
    @ObservedObject var mapState: MapState
    
    
    var body: some View {
        VStack {
            HStack {
                Text(self.mapState.place.title)
                .font(.title)
                .padding(.leading)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .background(
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
                .padding([.top, .trailing], 10.0)
                .onTapGesture {
                    self.mapState.state = .closed
                }
            }
            
            ScrollView(.vertical) {
                VStack {
                    
                    
                    PlaceDetailsButtons(mapState: self.mapState)
                    
                    HStack {
                        ImageStore.shared.image(name: self.mapState.place.id)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 150)
                            .clipped()
                            .cornerRadius(10)
                            .padding(.leading)
                        
                        
                            

                        
                        VStack {
                            Text("Nature").padding(5).background(Color.green).cornerRadius(10).foregroundColor(.white)
                            Spacer()
                            Text("Détails...").padding(5)
                            
                        }.padding(.horizontal, 5.0)
                        
                        Spacer()
                    }
                    
                    
                    
                    
                }
                
            }
        }
        
        //.background(Color.black)
        .edgesIgnoringSafeArea(.horizontal)
    }
}

struct PlaceMapDrawer_Previews: PreviewProvider {
    static var previews: some View {
        PlaceMapDrawer(mapState: MapState())
    }
}
