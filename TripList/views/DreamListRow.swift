//
//  ListRow.swift
//  TripList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import CoreData

struct DreamListRow: View {
    @EnvironmentObject var session: Session
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var dream: Dream
    
    var body: some View {
        HStack {
            Button(action: {
                self.toggle()
            }) {
                Image(systemName: self.dream.completed ? "circle.fill" : "circle").foregroundColor(.orange)
            }.buttonStyle(BorderlessButtonStyle())
            
            Text(dream.title ?? "")
        }
    }
    
    private func toggle(){
        self.dream.completed.toggle()
        do {
            try self.managedObjectContext.save()
            self.session.setComplete(placeId: self.dream.placeId ?? "0", value: self.dream.completed)
        } catch {
            print(error)
        }
    }
}
