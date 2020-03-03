//
//  ProgressionRegion.swift
//  TripList
//
//  Created by Julien Vanheule on 08/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import QGrid

struct ProgressionRegion: View {
    var region: PlaceRegion
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                RegionRow(title: "Villes", category: .city, regionId: self.region.id, width: geometry.size.width)
                RegionRow(title: "Histoire", category: .historical, regionId: self.region.id, width: geometry.size.width)
                RegionRow(title: "Musée", category: .museum, regionId: self.region.id, width: geometry.size.width)
                RegionRow(title: "Nature", category: .nature, regionId: self.region.id, width: geometry.size.width)
                RegionRow(title: "Évenements", category: .event, regionId: self.region.id, width: geometry.size.width)
            }
        }
        .navigationBarTitle(Text(region.name))
    }
}

struct ProgressionRegion_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionRegion(region: regionsData[0])
    }
}

struct ProgressionItem: View {
    var place: Place
    var size: CGFloat
    var completed: Bool = true
    
    
    var body: some View {
        NavigationLink(
            destination: LazyView(PlacePager(places: PlaceStore.shared.getAllForCategory(category: self.place.category, regionId: self.place.regionId), initialePlace: self.place))
        ) {
            ZStack {
                ImageStore.shared.image(forPlace: self.place)
                    .renderingMode(.original)
                    .resizable()
                    .grayscale(self.completed ? 0.7 : 0.0)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: self.size, height: self.size).clipped()
                    
                
                if completed {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green).font(.title)
                }
                
            }.cornerRadius(10).frame(width: self.size, height: self.size)
        }
    }
}

struct RegionRow: View {
    var title: String
    var category: PlaceCategory
    var regionId: String
    var width: CGFloat
    
    
    var body: some View {
        VStack {
            Text(self.title)
                .font(.headline)
                .foregroundColor(Color(AppStyle.color(for: self.category)))
                .padding(.leading, 15)
            
            
            RegionContent(places: PlaceStore.shared.getAllForCategory(category: self.category, regionId: self.regionId), width: width)
            
            
        }
    }
}

struct RegionContent: View {
    var places: [Place]
    var width: CGFloat
    let cols = UIDevice.current.userInterfaceIdiom == .phone ? 5 : 10
    let rows: Int
    
    
    init(places: [Place], width: CGFloat){
        self.width = width
        self.places = places
        self.rows = places.count/cols + 1
    }
    
    var body: some View {
        QGrid(places,
              columns: cols,
              columnsInLandscape: cols,
              vSpacing: 10,
              hSpacing: 10,
              vPadding: 10,
              hPadding: 10) { place in
                ProgressionItem(place: place, size: (self.width/CGFloat(self.cols))-5)
        }.frame(height: CGFloat(self.rows)*90)
        
        
                
    }
}
