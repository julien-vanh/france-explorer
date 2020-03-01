//
//  StoreArticlesRow.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct StoreArticlesRow: View {
    var articles: [Article] = []
    
    init() {
        articles = articlesData
    }
    
    var body: some View {
       VStack(alignment: .leading) {
            HStack
            {
                Text("Nos sélections")
                    .font(.title)
                Spacer()
            }.padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(articles) { article in
                        NavigationLink(
                            destination: StoreArticle(
                                article: article
                            )
                        ) {
                            ZStack {
                                ImageStore.shared.image(name: "\(article.id).jpg")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped().frame(width: 325, height: 170)
                                
                                Text(article.title)
                                    .fontWeight(.semibold)
                                    .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                                    .foregroundColor(.white).frame(width: 315, height: 170)
                            }
                            .cornerRadius(5)
                            .padding(.leading, 15)
                        }
                    }
                    Rectangle().opacity(0).frame(width:15)
                }
            }
        }
    }
}

struct StoreArticlesRow_Previews: PreviewProvider {
    static var previews: some View {
        StoreArticlesRow()
    }
}
