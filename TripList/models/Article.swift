//
//  Article.swift
//  TripList
//
//  Created by Julien Vanheule on 05/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation

struct Article: Decodable, Identifiable {
    var id: String
    var iap: Bool
    var places: [ArticlePlace]
    fileprivate var title: TranslatableField<String>
    fileprivate var description: TranslatableField<String>
    var illustration: Illustration!
    
    var titleLocalized: String {
        if( Locale.current.languageCode == "fr"){
            if let res = title.fr {
                return res
            }
        } else {
            if let res = title.en {
                return res
            } else if let res = title.fr { //fallback FR
                return res
            }
        }
        return ""
    }
    
    var descriptionLocalized: String! {
        if( Locale.current.languageCode == "fr"){
            if let res = description.fr {
                return res
            }
        } else {
            if let res = description.en {
                return res
            }
        }
        return nil
    }
}

struct ArticlePlace: Decodable {
    var order: Int
    var placeId: String
}

struct TranslatableField<T:Decodable>: Decodable {
    var fr: T!
    var en: T!
}
