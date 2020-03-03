//
//  StoreCategoriesRow.swift
//  TripList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import QGrid

struct StoreCategoriesRow: View {
    var storeCategories:[Category]
    let cols = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 5
    let rows:Int
    
    
    init(){
        self.storeCategories = PlaceStore.shared.getCategories()
        self.rows = self.storeCategories.count/cols + 1
    }
    
    var body: some View {
        VStack {
            HStack
            {
                Text("Catégories")
                    .font(.title)
                Spacer()
            }.padding(.horizontal, 10)
        
            QGrid(storeCategories,
                  columns: cols,
                  columnsInLandscape: cols,
                  vSpacing: 10,
                  hSpacing: 10,
                  vPadding: 15,
                  hPadding: 15) { category in
                    StoreCategoryItem(category: category)
            }.frame(height: CGFloat(self.rows)*60+30)
        }
    }
}

struct StoreCategoriesRow_Previews: PreviewProvider {
    static var previews: some View {
        StoreCategoriesRow().previewLayout(.fixed(width: 414, height: 300))
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
            
        }
    }
}
