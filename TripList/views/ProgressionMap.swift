//
//  PlacesMap.swift
//  TripList
//
//  Created by Julien Vanheule on 26/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import Combine
import MapKit


struct ProgressionMap: View {
    @FetchRequest(fetchRequest: Completion.getAllCompletion()) var completions: FetchedResults<Completion>
    let regionsCount = PlaceStore.shared.getRegions().count
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ProgressionMapController(completions: completionsArray()).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing, spacing: 10) {
                /*
                Button(action: {
                    //self.regionMap.view.userTrackingMode = .follow
                }) {
                    Image(systemName: "location")
                        .font(.title)
                        
                }
                .frame(width: 40, height: 40, alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
                */
                
                //Add other buttons here
                Text("\(getRegionsExploredCount())/\(regionsCount) " + NSLocalizedString("régions explorées", comment:""))
                    .foregroundColor(Color(UIColor.explored))
                    .padding(8)
                    .background(BlurView())
                    .cornerRadius(10)
            }
            .padding([.bottom, .trailing], 4)
        }
    }
    
    private func getRegionsExploredCount() -> Int{
        var regionsCompletion:[String: Int] = [:]
        
        self.completions.forEach { (completion) in
            if let place = PlaceStore.shared.get(id: completion.placeId!) {
                if regionsCompletion[place.regionId] != nil {
                    regionsCompletion[place.regionId]! += 1
                } else {
                    regionsCompletion[place.regionId] = 1
                }
            }
        }
        return regionsCompletion.keys.count
    }
    
    private func completionsArray() -> [Completion]{
        return completions.compactMap({$0})
    }
}

struct PlacesMap_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionMap()
    }
}
