//
//  AppState.swift
//  TripList
//
//  Created by Julien Vanheule on 01/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum UserDefaultsKeys : String {
    case cguAccepted = "cguAccepted"
    case reminderId = "reminderId"
    case launchCounter = "launchCounter"
}

class AppState: NSObject, ObservableObject {
    static let shared = AppState()
    
    @Published var cguAccepted: Bool = false
    @Published var isPremium: Bool = false
    
    //For the botttom drawer
    @Published var isPurchasePresented: Bool = false
    @Published var place: Place = PlaceStore.shared.getRandom(count: 1, premium: false)[0]
    @Published var state: BottomSheetState = .closed
    
    //For global alert message
    @Published var showingAlert: Bool = false
    @Published var alertErrorMessage: String = ""
    
    
    override init(){
        super.init()
        
        cguAccepted = UserDefaults.standard.bool(forKey: UserDefaultsKeys.cguAccepted.rawValue)
        isPremium = true//IAPManager.shared.isActive(productIdentifier: ProductsStore.ProductGuideFrance)
        //ProductsStore.shared.initializeProducts()
    }
    
    public func displayError(error: Error){
        print("display error Alert") //Ne marche pas si appelé depuis une modale !
        DispatchQueue.main.async {
            self.alertErrorMessage = error.localizedDescription
            self.showingAlert = true
        }
    }
    
    public func displayPurchasePageDrawer(){
        self.isPurchasePresented = true
        self.state = .full
    }
    
    public func displayPlaceDrawer(place: Place){
        self.isPurchasePresented = false
        self.place = place
        self.state = .middle
    }
    
    public func hideDrawer(){
        self.state = .closed
        self.isPurchasePresented = false
    }
    
    public func acceptCGU(){
        self.cguAccepted = true
        
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserDefaultsKeys.cguAccepted.rawValue)
        ud.synchronize()
    }
}
