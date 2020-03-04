//
//  SearchPage.swift
//  TripList
//
//  Created by Julien Vanheule on 04/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

import SwiftUI

struct SearchPage: View {
    
    
    @State private var searchText = ""
    @State private var isEditing = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                
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
                .navigationBarTitle(Text("Destinations"))
                .navigationBarHidden(isEditing)
                .overlay(
                    VStack{
                        if(isEditing) {
                            ExtractedView(searchText: searchText)
                        }
                    }
                )
            
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct ExtractedView: View {
    var searchText: String
    let array = ["Peter", "Paul", "Mary", "Anna-Lena", "George", "John", "Greg", "Thomas", "Robert", "Bernie", "Mike", "Benno", "Hugo", "Miles", "Michael", "Mikel", "Tim", "Tom", "Lottie", "Lorrie", "Barbara"]
    
    var body: some View {
        List {
            
                
            // Filtered list of names
            ForEach(PlaceStore.shared.getAllForSearch(search: searchText), id:\.self) {
                place in
                NavigationLink(destination: PlaceDetail(place: place)){
                    HStack(alignment: .center, spacing: 10) {
                        Image("mapicon.\(place.category)")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(8)
                            .background(Color(AppStyle.color(for: place.category)))
                            .cornerRadius(10)
                        Text(place.title).foregroundColor(.blue)
                    }
                    
                }
            }
                
                
            
        }.resignKeyboardOnDragGesture()
    }
}
