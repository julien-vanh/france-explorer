//
//  VibrationManager.swift
//  TripList
//
//  Created by Julien Vanheule on 29/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import SwiftUI

class VibrationManager {
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    static var shared = VibrationManager()
    
    init(){
        self.notificationFeedbackGenerator.prepare()
    }
    
    public func success(){
        self.notificationFeedbackGenerator.notificationOccurred(.success)
    }
}
