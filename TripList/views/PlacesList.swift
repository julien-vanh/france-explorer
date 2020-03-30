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
    
    init(filter: FilterModel){
        self.filterModel = filter
        
        Analytics.logEvent("PlacesList", parameters: [
            "category": filter.categoryFilter.rawValue
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
            Button(("Filtrer")) {
                self.filterOpen.toggle()
            }
        )
        .navigationBarTitle(Text("Destinations"))
        .sheet(isPresented: $filterOpen, content: {
            PlacesListFilter(filterModel : self.filterModel)
        })
    }
}



struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesList(filter: FilterModel(sortBy: .distance, categoryFilter: .all))
    }
}
