//
//  FilterModel.swift
//  TripList
//
//  Created by Julien Vanheule on 21/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation

enum SortOption {
    case distance
    case popularity
    
    static func labelFor(_ option: SortOption) -> String{
        switch option {
        case .distance:
            return NSLocalizedString("Distance", comment: "")
        default:
            return NSLocalizedString("Popularité", comment: "")
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
