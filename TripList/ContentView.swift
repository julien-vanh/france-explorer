//
//  ContentView.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import Combine

class MapState: ObservableObject{
    @Published var place: Place = PlaceStore.shared.get(id: "1") {
        didSet {
            self.bottomSheetShown = true
        }
    }
    @Published var bottomSheetShown: Bool = false
}

struct ContentView: View {
    @EnvironmentObject var session: Session
    @State private var selection = 0
    @ObservedObject var mapState = MapState()
    
    var body: some View {
        TabView(selection: $selection){
            Store()
                .tabItem {
                    VStack {
                        Image(systemName: "lightbulb")
                        Text("Idées")
                    }
                }
                .tag(0)
            PlacesMap(mapState: self.mapState)
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
                        isOpen: self.$mapState.bottomSheetShown,
                        maxHeight: geometry.size.height * 0.4
                    ) {
                        PlaceMapDrawer(mapState: self.mapState)
                    }
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
