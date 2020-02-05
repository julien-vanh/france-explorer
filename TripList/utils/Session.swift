//
//  Session.swift
//  LifeList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

fileprivate typealias _StateDictionary = [String: Bool]




class Session: ObservableObject {
    @Published var isPremium: Bool = false
    
    init(){
        //loadData()
    }

    
    /*
    //Progression
    public func isCompleted(placeId: String) -> Bool{
        return progression.keys.contains(placeId)
    }
    
    public func setComplete(placeId: String, value: Bool){
        if value == true {
            progression[placeId] = true
            interests[placeId] = true
        } else {
            progression[placeId] = nil
        }
    }
    
    public func saveData(){
        let ud = UserDefaults.standard
        ud.set(false, forKey: UserDefaultsKeys.premium.rawValue)
        ud.set(interests, forKey: UserDefaultsKeys.interest.rawValue)
        ud.set(progression, forKey: UserDefaultsKeys.progression.rawValue)
    }
    
    enum UserDefaultsKeys : String {
        case premium = "premium"
        case interest = "interest"
        case progression = "progression"
    }
    
    private func loadData(){
        let ud = UserDefaults.standard
        
        isPremium = ud.bool(forKey: UserDefaultsKeys.premium.rawValue)
        interests = ud.dictionary(forKey: UserDefaultsKeys.interest.rawValue) as? _StateDictionary  ?? [:]
        progression = ud.dictionary(forKey: UserDefaultsKeys.progression.rawValue) as? _StateDictionary ?? [:]
    }
    
    private func deleteSession(){
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
 
 */
}
