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
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        UIKitTabView([
            UIKitTabView.Tab(view: SearchPage(), title: "Destinations", image: "rectangle.stack.fill"),
            UIKitTabView.Tab(view: PlacesMap(), title: "Carte", image: "mappin.and.ellipse"),
            UIKitTabView.Tab(view: DreamList(), title: "Ma Liste", image: "list.bullet"),
            UIKitTabView.Tab(view: Progression(), title: "Progression", image: "text.badge.checkmark"),
            UIKitTabView.Tab(view: Parameters(), title: "Paramètres", image: "gear")
        ]).overlay(
            GeometryReader { geometry in
                    BottomSheetView(
                        state: self.$appState.state,
                        maxHeight: geometry.size.height * 0.9
                    ) {
                        PlaceMapDrawer(place: self.$appState.place)
                    }.offset(x: 0, y: 40)
                }
        , alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
