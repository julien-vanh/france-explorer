//
//  Session.swift
//  LifeList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

class Session: ObservableObject {
    @Published var dreams: [Dream] = dreamsData
    typealias _ProgressionDictionary = [String: Bool]
    fileprivate var progression: _ProgressionDictionary = [:]
    
    
    public func isInDream(placeId: String) -> Bool{
        return dreams.contains{$0.placeId == placeId}
    }
    
    public func isCompleted(placeId: String) -> Bool{
        return progression.keys.contains(placeId)
    }
    
    public func setComplete(placeId: String, value: Bool){
        if value == true {
            progression[placeId] = true
        } else {
            progression[placeId] = nil
        }
    }
}
