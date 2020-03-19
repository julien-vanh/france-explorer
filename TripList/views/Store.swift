//
//  SearchPage.swift
//  TripList
//
//  Created by Julien Vanheule on 04/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

import SwiftUI

struct Store: View {
    @State private var searchText = ""
    @State private var isEditing = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 10) {
                if !isEditing {
                    HStack {
                        Text("Destinations")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        Spacer()
                    }.padding(.top)
                    
                }
                
                // Search view
                SearchBarView(searchText: $searchText, isEditing: $isEditing)
                
                ScrollView(.vertical) {
                    
                    RandomButton()
                    
                    NearestPlaces()
                    
                    StoreArticlesRow()
                    
                    StoreCategoriesRow()
                    
                    StoreSuggestions()
                    
                    Rectangle().opacity(0).frame(height:40)
                }
                
                .overlay(
                    VStack{
                        if(isEditing) {
                            SearchResult(searchText: searchText)
                        }
                    }
                )
            }
            .navigationBarTitle(Text(""), displayMode: .large)
            .navigationBarHidden(true)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct SearchResult: View {
    @ObservedObject var appState = AppState.shared
    var searchText: String
    
    var body: some View {
        List {
            // Filtered list of names
            ForEach(PlaceStore.shared.getAllForSearch(search: searchText, premium: appState.isPremium), id:\.self) {
                place in
                NavigationLink(destination: PlaceDetail(place: place)){
                    HStack(alignment: .center, spacing: 10) {
                        PlaceListRow(place: place)
                    }
                }
            }
        }.resignKeyboardOnDragGesture()
    }
}

struct Carousel: View {
    @ObservedObject var appState = AppState.shared
    let CountInCarousel = 5
    
    var body: some View {
        GeometryReader { geometry in
            ImageCarouselView(numberOfImages: self.CountInCarousel) {
                ForEach(PlaceStore.shared.getRandom(count: self.CountInCarousel, premium: self.appState.isPremium)) { place in
                    NavigationLink(
                        destination: PlaceDetail(place: place)
                    ) {
                        ImageStore.shared.image(forPlace: place)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width-20, height:geometry.size.height)
                            .clipped().cornerRadius(15).padding(10)
                    }
                }
            }
        }.frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
    }
}

struct RandomButton: View {
    var body: some View {
        VStack(alignment: .center) {
            NavigationLink(destination: LazyView(PlaceDetail())) {
                HStack {
                    Image(systemName: "shuffle")
                        .font(.headline)
                    Text("Au hasard")
                        .fontWeight(.semibold)
                        .font(.headline).foregroundColor(.white)
                }
                .frame(width: 250.0, height: 40.0)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
            }
        }
    }
}

struct StoreSuggestions: View {
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack
                {
                    Text("Suggestions")
                        .font(.title)
                    Spacer()
                    /*
                    Button(action: {
                        //
                    })
                    {
                        Text("Voir plus")
                    }*/
            }.padding(.horizontal)
            
            PlaceGridCompact(places: PlaceStore.shared.getRandom(count: 9, premium: appState.isPremium))
        }
    }
}
