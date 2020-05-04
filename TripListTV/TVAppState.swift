//
//  TVAppState.swift
//  TripListTV
//
//  Created by Julien Vanheule on 04/05/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//
import Foundation

/*
enum UserDefaultsKeys : String {
    case cguAccepted = "cguAccepted"
}
*/

class TVAppState: NSObject {
    static let shared = TVAppState()
    
    var isPremium: Bool = false
    
    
    override init(){
        super.init()
        
        //isPremium = IAPManager.shared.isActive(productIdentifier: ProductsStore.ProductGuideFrance)
        //ProductsStore.shared.initializeProducts()
    }
}
