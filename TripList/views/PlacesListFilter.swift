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

class FilterModel: NSObject {
    var sortBy: SortOption = .distance
    var categoryFilter: PlaceCategory = .all
    
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
    
    @Binding var filterModel: FilterModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $filterModel.sortBy, label: Text("Trier par")) {
                        ForEach(sortOptions, id: \.self) { option in
                            Text(SortOption.labelFor(option))

                        }
                    }
                }
                
                Section {
                    Picker(selection: $filterModel.categoryFilter, label: Text("Type de destinations")) {
                        ForEach(categories, id: \.self) { option in
                            Text(PlaceStore.shared.getCategory(placeCategory: option).title)

                        }
                    }
                }
                
                Section {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Filtrer")
                    }
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
        }
    }
}


struct PlacesListFilter_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListFilter(filterModel: .constant(FilterModel()))
    }
}
