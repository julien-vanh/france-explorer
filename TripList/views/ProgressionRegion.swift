//
//  ProgressionRegion.swift
//  TripList
//
//  Created by Julien Vanheule on 08/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

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
            
            SeparationBar()
            Spacer()
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
        VStack {
            ForEach((0...(self.rows-1)), id: \.self) { row in
                HStack(alignment: .top, spacing: 0) {
                    ForEach((0...(self.cols-1)), id: \.self) { col in
                        VStack{
                            if self.places.count > (row*self.cols+col) {
                                ProgressionItem(place: self.places[row*self.cols+col], size: (self.width/CGFloat(self.cols))-4).padding(2)
                            }
                        }
                    }
                    Spacer()
                }
            }
            
        }.padding(.leading, 5)
                
    }
}
