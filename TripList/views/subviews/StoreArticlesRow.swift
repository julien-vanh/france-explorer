//
//  StoreArticlesRow.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct StoreArticlesRow: View {
    var articles: [Article] = Array(articlesData.shuffled().prefix(5))
    
    
    var body: some View {
       VStack(alignment: .leading) {
            HStack
            {
                Text("Nos sélections")
                    .font(.title)
                Spacer()
                NavigationLink(destination: ArticlesList()){
                    HStack {
                        Text("Voir plus")
                        Image(systemName: "chevron.right")
                    }.foregroundColor(.blue)
                }
            }.padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(articles) { article in
                        NavigationLink(
                            destination: ArticleDetail(
                                article: article
                            )
                        ) {
                            ZStack {
                                ImageStore.shared.image(name: article.illustration.path)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped().frame(width: 325, height: 170)
                                
                                Text(article.titleLocalized)
                                    .fontWeight(.semibold)
                                    .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                                    .foregroundColor(.white).frame(width: 315, height: 170)
                            }
                            .cornerRadius(5)
                            .padding(.leading, 10)
                        }
                    }
                    Rectangle().opacity(0).frame(width:15)
                }
            }.frame(height: 180)
        }
    }
}

struct StoreArticlesRow_Previews: PreviewProvider {
    static var previews: some View {
        StoreArticlesRow()
    }
}
