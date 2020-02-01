//
//  PlaceDetailsButtons.swift
//  TripList
//
//  Created by Julien Vanheule on 30/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceDetailsButtons: View {
    @EnvironmentObject var session: Session
    var place: Place
    @State private var isComplete: Bool = false
    @State private var isInDream: Bool = false
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        HStack {
            Button(action: {
                if self.session.isCompleted(placeId: self.place.id) {
                    self.session.setComplete(placeId: self.place.id, value: false)
                    self.isComplete = false
                } else {
                    self.session.setComplete(placeId: self.place.id, value: true)
                    self.isComplete = true
                    
                    self.session.dreams.removeAll(where: { self.place.id == $0.placeId }) // Si completer, on le retire auto des Dreams
                    self.isInDream = false
                    self.notificationFeedbackGenerator.notificationOccurred(.success)
                }
            }) {
                HStack {
                    Image(systemName: self.isComplete ? "checkmark.circle" : "circle")
                    Text("Déjà vu")
                }
                .font(.headline)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
            
            
            if (!self.isComplete) {
                if self.isInDream {
                    Button(action: {
                        self.session.dreams.removeAll(where: { self.place.id == $0.placeId })
                        self.isInDream = false
                    }) {
                        Text("Retirer de Ma Liste")
                            .font(.headline)
                    }
                    .padding()
                    .foregroundColor(.red)
                } else {
                    HStack {
                        Button(action: {
                            self.session.dreams.append(Dream(place: self.place))
                            self.isInDream = true
                            self.notificationFeedbackGenerator.notificationOccurred(.success)
                        }) {
                            HStack{
                                Image(systemName: "plus")
                                Text("Ajouter à Ma Liste")
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.orange)
                        .cornerRadius(10)
                        
                        
                    }
                }
            }
        }.onAppear(perform: {
            self.notificationFeedbackGenerator.prepare()
            self.isComplete = self.session.isCompleted(placeId: self.place.id)
            self.isInDream = self.session.isInDream(placeId: self.place.id)
        })
    }
}
