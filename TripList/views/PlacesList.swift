//
//  HintList.swift
//  LifeList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlacesList: View {
    var category: Category!
    var places: [Place] = []
    
    @State var menuOpen: Bool = false
    
    init(){
        places = PlaceStore.shared.getRandom(count: 100)
    }
    
    init(category: Category){
        self.category = category
        places = PlaceStore.shared.getAllForCategory(category: category.category)
    }
    
    var body: some View {
        ZStack {
            List{
                ForEach(places) { place in
                    NavigationLink(
                        destination: PlacePager(places: self.places, initialePlace:place)
                    ) {
                        Text(place.title)
                    }
                }
            }
            
            SideMenu(width: 270,
                     isOpen: self.menuOpen,
                     menuClose: self.openMenu)
        }
        
        
        .navigationBarItems(trailing:
            Button("Filtrer") {
                self.openMenu()
            }
        )
        .navigationBarTitle("Destinations", displayMode: .inline)
    }
    
    func openMenu() {
        self.menuOpen.toggle()
    }
}

struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesList(category: Category(id: 2, category: .historical, title: "Lieux", image: ""))
    }
}
