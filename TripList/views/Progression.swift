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
                ProgressionListHeader()
                
                ForEach(PlaceStore.shared.getRegions()) { region in
                    NavigationLink(destination: LazyView(ProgressionRegion(region: region)), label: {
                        ProgressionLine(region: region)
                    })
                }
            }
            .navigationBarTitle(Text("Progression"), displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Progression_Previews: PreviewProvider {
    static var previews: some View {
        Progression()
    }
}





struct ProgressionLine: View {
    var region: PlaceRegion
    @FetchRequest(fetchRequest: Completion.getAllCompletion()) var completions: FetchedResults<Completion>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Text(region.name)
                    .font(.headline)
                Spacer()
                
                HStack {
                    Text("\(getCompletedCount())/\(PlaceStore.shared.getAllForRegion(regionId: region.id).count)")
                    .font(.caption)
                    .foregroundColor(.white)
                    
                    
                    Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                }
                .padding(3)
                .background(Color(.systemGray2))
                .cornerRadius(10)
            }
            
            ProgressBar(value: CGFloat(getCompletedCount())/CGFloat(PlaceStore.shared.getAllForRegion(regionId: region.id).count))
        }
    }
    
    func completedPlaceCount() -> String {
        let placesCountForRegions = PlaceStore.shared.getAllForRegion(regionId: region.id).count
        return "\(getCompletedCount())/\(placesCountForRegions)"
    }
    
    func getCompletedCount() -> Int {
        let completedPlaces = completions.compactMap({PlaceStore.shared.get(id: $0.placeId!)})
        return completedPlaces.filter { return $0.regionId == region.id}.count
    }
}

struct ProgressionListHeader: View {
    @FetchRequest(fetchRequest: Completion.getAllCompletion()) var completions: FetchedResults<Completion>
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("\(getRegionsCompletion().keys.count)/\(PlaceStore.shared.getRegions().count) " + NSLocalizedString("régions visitées", comment: ""))
                .foregroundColor(Color(UIColor.explored))
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
