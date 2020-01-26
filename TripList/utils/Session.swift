//
//  Session.swift
//  LifeList
//
//  Created by Julien Vanheule on 20/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

class Session: ObservableObject {
    @Published var dreams: [Dream] = []
}
