//
//  TVAppState.swift
//  TripListTV
//
//  Created by Julien Vanheule on 04/05/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//
import Foundation


class TVAppState: NSObject {
    static let shared = TVAppState()
    
    var isPremium: Bool = false
    
    
    override init(){
        super.init()
        
        isPremium = TVIAPManager.shared.isActive(productIdentifier: TVProductsStore.ProductGuideFrance)
        TVProductsStore.shared.initializeProducts()
    }
}
