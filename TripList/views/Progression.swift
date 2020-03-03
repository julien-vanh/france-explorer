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
    @State var showingDetail = false
    
    var body: some View {
        NavigationView {
            
            List {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("France").font(.title)
                            Text("21/25 régions visitées").foregroundColor(.green)
                        }
                        
                        Spacer()
                        ImageStore.shared.image(name: "france.png")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 50)
                            .clipped()
                    }
                    
                    
                }
                
                
                    
                
                
                ForEach(PlaceStore.shared.getRegions()) { region in
                    NavigationLink(destination: LazyView(ProgressionRegion(region: region)), label: {
                        ProgressionLine(region: region)
                    })
                    
                }
                
            }
            .navigationBarTitle("Progression", displayMode: .inline)
            .sheet(isPresented: $showingDetail) {
                 Parameters()
            }
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
        HStack {
            Text(region.name)
            Spacer()
            Text("Terra incognita")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}
