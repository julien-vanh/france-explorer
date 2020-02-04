//
//  StoreCategoriesRow.swift
//  TripList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct StoreCategoriesRow: View {
    var storeCategories = PlaceStore.shared.getCategories()
    
    var body: some View {
       VStack(alignment: .leading) {
            Text("Par catégorie")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(storeCategories) { storeCategory in
                        NavigationLink(
                            destination: PlacesList()
                        ) {
                            Text(storeCategory.title)
                                .fontWeight(.semibold)
                                .frame(width: 155, height: 155)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(5)
                                .padding(.leading, 15)
                        }
                    }
                }
            }
            .frame(height: 155)
        }
    }
}

struct StoreCategoriesRow_Previews: PreviewProvider {
    static var previews: some View {
        StoreCategoriesRow().previewLayout(.fixed(width: 400, height: 200))
    }
}
