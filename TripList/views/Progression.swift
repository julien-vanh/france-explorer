//
//  Progression.swift
//  LifeList
//
//  Created by Julien Vanheule on 24/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import QGrid

struct Progression: View {
    
    
    var body: some View {
        NavigationView {
            
            List {
                HStack{
                    Text("Totale : 2%")
                }
                
                ForEach(PlaceStore.shared.getRegions()) { region in
                    NavigationLink(destination: LazyView(ProgressionRegion(region: region)), label: {
                        ProgressionLine(region: region)
                    })
                    
                }
                
            }
            .navigationBarTitle("Progression")
        }
    }
}

struct Progression_Previews: PreviewProvider {
    static var previews: some View {
        Progression()
    }
}





struct ProgressionLine: View {
    var region: PlaceRegion
    
    var body: some View {
        HStack{
            Text(region.name)
        }
    }
}
