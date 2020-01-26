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
            
        }.edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Session())
    }
}
