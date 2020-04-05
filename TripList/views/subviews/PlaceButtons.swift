//
//  PlaceDetailsButtons.swift
//  TripList
//
//  Created by Julien Vanheule on 30/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceButtons: View {
    var place: Place
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Dream.getAllDreams()) var dreams: FetchedResults<Dream>
    var fetchRequest: FetchRequest<Completion>
    var completions: FetchedResults<Completion> { fetchRequest.wrappedValue }
    
    init(place: Place) {
        self.place = place
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
            VibrationManager.shared.success()
        } catch {
            print(error)
        }
    }
    
    private func getDreamIndexIfExist() -> Int? {
        return dreams.firstIndex(where: {$0.placeId == place.id})
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: {
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
                    
                    VibrationManager.shared.success()
                }
                self.saveContext()
            }) {
                HStack {
                    Image(systemName: (completions.first != nil) ? "checkmark.circle.fill" : "circle")
                    Text("Exploré")
                }
                .font(.headline)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color(UIColor.explored))
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
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                } else {
                    Button(action: {
                        self.addDream()
                    }) {
                        HStack{
                            Image(systemName: "text.badge.plus")
                            Text("Ajouter à Ma Liste")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            
            Spacer()
    
        }
    }
}
