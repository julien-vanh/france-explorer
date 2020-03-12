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
}

class AppState: NSObject, ObservableObject {
    static let shared = AppState()
    
    @Published var place: Place = PlaceStore.shared.getRandom(count: 1, premium: false)[0] {
        didSet {
            if self.state == .closed {
                self.state = .middle
            }
        }
    }
    @Published var state: BottomSheetState = .closed
    @Published var update: Bool = false
    @Published var cguAccepted: Bool = false
    @Published var isPremium: Bool = false
    
    override init(){
        super.init()
        
        let ud = UserDefaults.standard
        cguAccepted = ud.bool(forKey: UserDefaultsKeys.cguAccepted.rawValue)
    }
    
    
    static func openLinkInBrowser(link: String){
        var urlString = link
        if !link.hasPrefix("http"){
            urlString = "http://"+link
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    public func acceptCGU(){
        cguAccepted = true
        
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserDefaultsKeys.cguAccepted.rawValue)
    }
    
    
}
