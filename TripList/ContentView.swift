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
            UIKitTabView.Tab(
                view: Store(),
                title: NSLocalizedString("Destinations", comment: ""),
                image: "rectangle.stack.fill"
            ),
            UIKitTabView.Tab(
                view: ProgressionMap(),
                title: NSLocalizedString("Carte", comment: ""),
                image: "mappin.and.ellipse"
            ),
            UIKitTabView.Tab(
                view: DreamList(),
                title: NSLocalizedString("Ma Liste", comment: ""),
                image: "list.bullet"
            ),
            UIKitTabView.Tab(
                view: Progression(),
                title: NSLocalizedString("Progression", comment: ""),
                image: "text.badge.checkmark"
            ),
            UIKitTabView.Tab(
                view: Parameters(),
                title: NSLocalizedString("Paramètres", comment: ""),
                image: "gear"
            )
        ]).overlay(
            GeometryReader { geometry in
                if(!self.appState.cguAccepted){
                    LaunchCarousel()
                } else {
                    BottomSheetView(
                        state: self.$appState.state,
                        maxHeight: geometry.size.height * 0.9
                    ) {
                        ZStack(alignment: .topTrailing) {
                            
                            PlaceDrawer(place: self.$appState.place)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .background(
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 40, height: 40)
                            )
                            .frame(width: 40, height: 40)
                            .padding([.top, .trailing], 20.0)
                            .onTapGesture {
                                self.appState.state = BottomSheetState.closed
                            }
                        }
                        
                    }.offset(x: 0, y: 40)
                }
            }
        , alignment: .bottom)
        .alert(isPresented: $appState.showingAlert) {
            Alert(title: Text("Erreur"), message: Text(appState.alertErrorMessage), dismissButton: .default(Text("OK")))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
