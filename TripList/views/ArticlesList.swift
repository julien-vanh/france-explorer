//
//  ArticlesList.swift
//  TripList
//
//  Created by Julien Vanheule on 03/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct ArticlesList: View {
    var articles: [Article] = []
    
    init() {
        articles = articlesData
    }
    
    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRow(article: article)
            }
        }.navigationBarTitle("Sélections", displayMode: .inline)
    }
}

struct ArticlesList_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesList()
    }
}

struct ArticleRow: View {
    var article: Article
    
    var body: some View {
        NavigationLink(destination: StoreArticle(article: article)){
            HStack(alignment: .center) {
                
                ImageStore.shared.image(name: "\(article.id).jpg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 100)
                    .clipped()
                
                VStack(alignment: .leading){
                    Text(article.title)
                }
            }
        }
    }
}
