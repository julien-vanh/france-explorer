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
    
    let rows = UIDevice.current.userInterfaceIdiom == .phone ? 3 : 1
    let cols = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 5
    
    var body: some View {
        VStack {
            HStack
            {
                Text("Catégories")
                    .font(.title)
                Spacer()
                
            }.padding(.horizontal, 10)
        
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach((0...(cols-1)), id: \.self) { col in
                        VStack {
                            ForEach((0...(self.rows-1)), id: \.self) { row in
                                VStack{
                                    if self.storeCategories.count > (row*self.cols+col) {
                                        StoreCategoryItem(category: self.storeCategories[row*self.cols+col])
                                            .frame(width: 180)
                                    }
                                }
                            }
                        }
                    }
                    Rectangle().opacity(0).frame(width:50)
                }
            }
        }.frame(height: CGFloat(50*rows+60))
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
                .padding([.leading, .bottom], 10)
            
        }
    }
}
