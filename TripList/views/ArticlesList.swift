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
        }.navigationBarTitle(Text("Sélections"))
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
        NavigationLink(destination: ArticleDetail(article: article)){
            HStack(alignment: .center) {
                
                ImageStore.shared.localImage(name: article.illustration.path)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 100)
                    .cornerRadius(5)
                
                VStack(alignment: .leading){
                    Text(article.titleLocalized)
                }
            }
        }
    }
}
