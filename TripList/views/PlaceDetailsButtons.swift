//
//  PlaceDetailsButtons.swift
//  TripList
//
//  Created by Julien Vanheule on 30/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceDetailsButtons: View {
    var place: Place
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Dream.getAllDreams()) var dreams: FetchedResults<Dream>
    var fetchRequest: FetchRequest<Completion>
    var completions: FetchedResults<Completion> { fetchRequest.wrappedValue }
    @ObservedObject var mapState: MapState
    
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    init(place: Place) {
        mapState = MapState()
        self.place = place
        fetchRequest = FetchRequest<Completion>(entity: Completion.entity(), sortDescriptors: [], predicate: NSPredicate(format: "placeId == %@", place.id))
    }
    
    init(mapState: MapState) {
        self.mapState = mapState
        self.place = mapState.place
        fetchRequest = FetchRequest<Completion>(entity: Completion.entity(), sortDescriptors: [], predicate: NSPredicate(format: "placeId == %@", place.id))
    }
    
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
            self.mapState.update.toggle()
        } catch {
            print(error)
        }
    }
    
    private func getDreamIndexIfExist() -> Int? {
        return dreams.firstIndex(where: {$0.placeId == place.id})
    }
    
    var body: some View {
        HStack {
            Button(action: {
                print("click")
                if self.completions.first != nil {
                    self.completions.forEach({
                        self.managedObjectContext.delete($0)
                    })
                } else {
                    let completion = Completion(context: self.managedObjectContext)
                    completion.configure(placeId: self.place.id)
                    
                    // Si dans la Dreams liste, on complete le Dream
                    if let index = self.getDreamIndexIfExist() {
                        let item = self.dreams[index]
                        item.completed = true
                    }
                    
                    self.notificationFeedbackGenerator.notificationOccurred(.success)
                }
                self.saveContext()
            }) {
                HStack {
                    Image(systemName: (completions.first != nil) ? "checkmark.circle" : "circle")
                    Text("Déjà vu")
                }
                .font(.headline)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
            
            
            if (completions.first == nil) {
                
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
        })
    }
}
