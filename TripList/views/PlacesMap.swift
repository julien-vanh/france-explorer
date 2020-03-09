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


struct PlacesMap: View {
    @FetchRequest(fetchRequest: Completion.getAllCompletion()) var completions: FetchedResults<Completion>
    //var regionMap = RegionsMapController(regionsCompletion: getRegionsCompletion())
    let regionsCount = PlaceStore.shared.getRegions().count
    
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            RegionsMapController(regionsCompletion: getRegionsCompletion()).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing, spacing: 10) {
                Button(action: {
                    //self.regionMap.view.userTrackingMode = .follow
                }) {
                    Image(systemName: "location")
                        .font(.title)
                        
                }
                .frame(width: 40, height: 40, alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
                
                //Add other buttons here
                Text("\(completions.count)/\(regionsCount) régions visitées")
                    .foregroundColor(Color(UIColor.mapOverlayExploring)).padding(8).background(Color.white)
                    .cornerRadius(10)
            }
            
            .padding(.top, 50.0)
            .padding(.trailing, 4.0)
        }
    }
    
    private func getRegionsCompletion() -> [String: Int]{
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
        
        return regionsCompletion
    }
}

struct PlacesMap_Previews: PreviewProvider {
    static var previews: some View {
        PlacesMap()
    }
}
