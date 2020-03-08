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
    @FetchRequest(fetchRequest: Completion.getAllCompletion()) var completions: FetchedResults<Completion>
    
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("France").font(.title)
                            Text("\(getRegionsCompletion().keys.count)/\(PlaceStore.shared.getRegions().count) régions visitées").foregroundColor(.green)
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
                        ProgressionLine(region: region, completedCount: self.getRegionsCompletion()[region.id] ?? 0)
                    })
                    
                }
                
            }
            .navigationBarTitle("Progression", displayMode: .inline)
            .sheet(isPresented: $showingDetail) {
                 Parameters()
            }
        }
    }
    
    func getRegionsCompletion() -> [String: Int]{
        var regionsCompletion:[String: Int] = [:]
        
        completions.forEach { (completion) in
            if let place = PlaceStore.shared.get(id: completion.placeId!) {
                if regionsCompletion[place.regionId] != nil {
                    regionsCompletion[place.regionId]! += 1
                } else {
                    regionsCompletion[place.regionId] = 1
                }
            }
        }
        
        return regionsCompletion
    }
}

struct Progression_Previews: PreviewProvider {
    static var previews: some View {
        Progression()
    }
}





struct ProgressionLine: View {
    var region: PlaceRegion
    var completedCount: Int
    
    var body: some View {
        HStack {
            Text(region.name)
            Spacer()
            Text(completedPlaceCount())
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    
    func completedPlaceCount() -> String {
        let placesCountForRegions = PlaceStore.shared.getAllForRegion(regionId: region.id).count
        return "\(completedCount)/\(placesCountForRegions)"
    }
}
