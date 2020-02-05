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
            Text("Catégories")
                .font(.title)
                .padding([.top, .leading], 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    VStack {
                        StoreCategoryItem(category: self.storeCategories[0])
                        StoreCategoryItem(category: self.storeCategories[1])
                    }
                    
                    VStack {
                        StoreCategoryItem(category: self.storeCategories[2])
                        StoreCategoryItem(category: self.storeCategories[3])
                    }
                    
                    VStack {
                        StoreCategoryItem(category: self.storeCategories[4])
                        StoreCategoryItem(category: self.storeCategories[5])
                    }
                    
                    VStack {
                        StoreCategoryItem(category: self.storeCategories[6])
                    }
                    Rectangle().opacity(0).frame(width:15)
                }
            }
        }
    }
}

struct StoreCategoriesRow_Previews: PreviewProvider {
    static var previews: some View {
        StoreCategoriesRow().previewLayout(.fixed(width: 400, height: 200))
    }
}

struct StoreCategoryItem: View {
    var category: Category
    
    var body: some View {
        NavigationLink(
            destination: PlacesList(category: category)
        ) {
            Text(category.title)
                .fontWeight(.semibold)
                .frame(width: 155, height: 50)
                .foregroundColor(.white)
                .background(Color(AppStyle.color(for: category.category)))
                .cornerRadius(5)
                .padding([.leading, .bottom], 15)
            
        }
    }
}
