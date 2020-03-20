//
//  PlacesListFilter.swift
//  TripList
//
//  Created by Julien Vanheule on 19/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

enum SortOption {
    case distance
    case popularity
    
    static func labelFor(_ option: SortOption) -> String{
        switch option {
        case .distance:
            return "Distance"
        default:
            return "Popularité"
        }
    }
}

class FilterModel: ObservableObject {
    @Published var sortBy: SortOption = .distance
    @Published var categoryFilter: PlaceCategory = .all
    
    convenience init(sortBy: SortOption, categoryFilter: PlaceCategory){
        self.init()
        self.sortBy = sortBy
        self.categoryFilter = categoryFilter
    }
    
    func reset(){
        sortBy = .distance
        categoryFilter = .all
    }
}


struct PlacesListFilter: View {
    let sortOptions: [SortOption] = [
        SortOption.distance,
        SortOption.popularity
    ]
    let categories: [PlaceCategory] = [
        PlaceCategory.all,
        PlaceCategory.city,
        PlaceCategory.event,
        PlaceCategory.museum,
        PlaceCategory.nature,
        PlaceCategory.historical
    ]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var filterModel: FilterModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $filterModel.sortBy, label: Text("Trier par")) {
                        ForEach(sortOptions, id: \.self) { option in
                            Text(SortOption.labelFor(option)).tag(option)
                        }
                    }
                }
                
                Section {
                    Picker(selection: $filterModel.categoryFilter, label: Text("Type de destination")) {
                        ForEach(categories, id: \.self) { option in
                            Text(PlaceStore.shared.getCategory(placeCategory: option).titlePlural).tag(option)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Filtrer")
                            .fontWeight(.semibold)
                            .font(.headline).foregroundColor(.white)
                            .frame(width: 250.0, height: 40.0)
                            .foregroundColor(.white)
                            .background(Color.blue).cornerRadius(10)
                    }
                    
                    Spacer()
                }
                
            }
            .navigationBarTitle("Filtrer", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Réinitialiser") {
                    self.filterModel.reset()
                }
            , trailing:
                Button("Annuler") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct PlacesListFilter_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListFilter(filterModel: FilterModel())
    }
}
