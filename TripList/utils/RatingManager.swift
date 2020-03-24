//
//  RatingManager.swift
//  TripList
//
//  Created by Julien Vanheule on 22/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import StoreKit

class RatingManager: NSObject {
    
    static func countLaunchAndRate(){
        let ud = UserDefaults.standard
        
        let counter = ud.integer(forKey: UserDefaultsKeys.launchCounter.rawValue)
        
        //print("Counter launch", counter)
        if counter == 4 || counter == 10 || counter == 30 {
            SKStoreReviewController.requestReview()
        }
        
        ud.set(counter+1, forKey: UserDefaultsKeys.launchCounter.rawValue)
    }
}
