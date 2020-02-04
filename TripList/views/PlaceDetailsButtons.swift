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
    //@State private var isComplete: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Dream.getAllDreams()) var dreams: FetchedResults<Dream>
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    private func addDream(){
        let dream = Dream(context: self.managedObjectContext)
        dream.configure(place: self.place)
        dream.order = (self.dreams.last?.order ?? 0) + 1
        saveContext()
    }
    
    private func saveContext(){
        do {
            try self.managedObjectContext.save()
            self.notificationFeedbackGenerator.notificationOccurred(.success)
        } catch {
            print(error)
            //TODO
        }
    }
    
    private func getDreamIndexIfExist() -> Int? {
        return dreams.firstIndex(where: {$0.placeId == place.id})
    }
    
    var body: some View {
        HStack {
            Button(action: {
                if self.session.isCompleted(placeId: self.place.id) {
                    self.session.setComplete(placeId: self.place.id, value: false)
                    
                } else {
                    self.session.setComplete(placeId: self.place.id, value: true)
                    
                    
                    // Si completer, on le retire automatiquement des Dreams si contenu dans le dreams
                    if let index = self.getDreamIndexIfExist() {
                        let item = self.dreams[index]
                        item.completed = true
                        self.saveContext()
                    }
                    
                    self.notificationFeedbackGenerator.notificationOccurred(.success)
                }
            }) {
                HStack {
                    Image(systemName: self.session.isCompleted(placeId: self.place.id) ? "checkmark.circle" : "circle")
                    Text("Déjà vu")
                }
                .font(.headline)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
            
            
            if (!self.session.isCompleted(placeId: self.place.id)) {
                
                if getDreamIndexIfExist() != nil {
                    Button(action: {
                        let item = self.dreams[self.getDreamIndexIfExist()!]
                        self.managedObjectContext.delete(item)
                        self.saveContext()
                    }) {
                        Text("Retirer de Ma Liste")
                            .font(.headline)
                    }
                    .padding()
                    .foregroundColor(.red)
                } else {
                    Button(action: {
                        self.addDream()
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
        }.onAppear(perform: {
            self.notificationFeedbackGenerator.prepare()
            //self.isComplete = self.session.isCompleted(placeId: self.place.id)
            //print("compute isComplete", self.isComplete, self.place)
        })
    }
}
