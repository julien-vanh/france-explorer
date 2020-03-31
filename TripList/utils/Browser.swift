//
//  Browser.swift
//  TripList
//
//  Created by Julien Vanheule on 31/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//
import Foundation
import SwiftUI

class Browser : NSObject {
    static func openLinkInBrowser(link: String){
        var urlString = link
        if !link.hasPrefix("http"){
            urlString = "http://"+link
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
