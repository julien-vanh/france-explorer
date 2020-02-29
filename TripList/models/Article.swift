//
//  Article.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation

struct Article: Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var iap: Bool
    var places: [ArticlePlace]
    
    fileprivate var descriptionFr: ArticleDescription!
    fileprivate var descriptionEn: ArticleDescription!
    var content: ArticleDescription! {
        if( Locale.current.languageCode == "fr"){
            return descriptionFr
        } else {
            if(descriptionEn != nil) {
                return descriptionEn
            } else {
                return descriptionFr
            }
        }
    }
}

struct ArticlePlace: Hashable, Codable {
    var order: Int
    var placeId: String
}

struct ArticleDescription: Hashable, Codable {
    var title: String!
    var description: String
}
