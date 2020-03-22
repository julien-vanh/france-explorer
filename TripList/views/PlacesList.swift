//
//  HintList.swift
//  LifeList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import FirebaseAnalytics

struct PlacesList: View {
    @ObservedObject var appState = AppState.shared
    @State private var filterOpen: Bool = false
    @ObservedObject private var filterModel: FilterModel
    
    init(category: Category){
        self.filterModel = FilterModel(sortBy: .distance, categoryFilter: category.category)
        
        Analytics.logEvent("PlacesList", parameters: [
            "category": category.category.rawValue
        ])
    }
    
    var body: some View {
        List{
            ForEach(PlaceStore.shared.getPlacesFor(filter: self.filterModel, premium: appState.isPremium, count: 50, position: LocationManager.shared.lastLocation)) { place in
                NavigationLink(
                    destination: PlaceDetail(place: place)
                ) {
                    PlaceListRow(place: place)
                }
            }
        }
        .navigationBarItems(trailing:
            Button("Filtrer") {
                self.filterOpen.toggle()
            }
        )
        .navigationBarTitle(Text("Destinations"), displayMode: .inline)
        .sheet(isPresented: $filterOpen, content: {
            PlacesListFilter(filterModel : self.filterModel)
        })
    }
}



struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesList(category: Category(id: 2, category: .historical, title: "Lieux", image: ""))
    }
}
