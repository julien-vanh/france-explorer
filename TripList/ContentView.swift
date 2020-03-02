//
//  ContentView.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import Combine



struct ContentView: View {
    @EnvironmentObject var session: Session
    @State private var selection = 0
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        TabView(selection: $selection){
            Store()
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Destinations")
                    }
                }
                .tag(0)
            PlacesMap()
                .tabItem {
                    VStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Carte")
                    }
                }
                .tag(1)
            DreamList()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Ma Liste")
                    }
                }
                .tag(2)
            Progression()
                .tabItem {
                    VStack {
                        Image(systemName: "text.badge.checkmark")
                        Text("Progression")
                    }
                }
                .tag(3)
            
            }.overlay(
                GeometryReader { geometry in
                    BottomSheetView(
                        state: self.$appState.state,
                        maxHeight: geometry.size.height * 0.9
                    ) {
                        PlaceMapDrawer(place: self.$appState.place)
                    }.offset(x: 0, y: 40)
                }
                , alignment: .bottom)
            .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Session())
    }
}
