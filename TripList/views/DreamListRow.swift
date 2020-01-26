//
//  ListRow.swift
//  TripList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct DreamListRow: View {
    @EnvironmentObject var session: Session
    var dream: Dream
    
    var index: Int {
        session.dreams.firstIndex(where: { $0.id == dream.id }) ?? -1
    }
    
    var body: some View {
        HStack {
            if index >= 0 {
                Button(action: {
                    self.session.dreams[self.index]
                    .completed.toggle()
                }) {
                    Image(systemName: self.session.dreams[self.index]
                        .completed ? "circle.fill" : "circle")
                        .foregroundColor(.orange)
                }.buttonStyle(BorderlessButtonStyle())
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
            
            Text(dream.title)
        }
    }
}

struct DreamListRow_Previews: PreviewProvider {
    static var previews: some View {
        DreamListRow(dream: Dream(place: PlaceStore.shared.get(id: "2"))).environmentObject(Session())
    }
}
