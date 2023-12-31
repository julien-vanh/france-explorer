//
//  PlaceDetailsButtons.swift
//  TripList
//
//  Created by Julien Vanheule on 30/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct PlaceButtonsMini: View {
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
        HStack {
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
                Image(systemName: (completions.first != nil) ? "checkmark.circle" : "circle")
            }
            .buttonStyle(BorderlessButtonStyle()).padding()
            .foregroundColor(.white)
            .background(Color(UIColor.explored))
            .cornerRadius(10)
            .font(.headline)
            
            
            if (completions.first == nil) {
                
                if getDreamIndexIfExist() != nil {
                    Button(action: {
                        let item = self.dreams[self.getDreamIndexIfExist()!]
                        self.managedObjectContext.delete(item)
                        self.saveContext()
                    }) {
                        Image(systemName: "text.badge.minus")
                    }
                    .buttonStyle(BorderlessButtonStyle()).padding()
                    .foregroundColor(.red)
                    .cornerRadius(10)
                    .font(.headline)
                } else {
                    Button(action: {
                        self.addDream()
                    }) {
                        Image(systemName: "text.badge.plus")
                    }
                    .buttonStyle(BorderlessButtonStyle()).padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .font(.headline)
                }
            }
        }
    }
}
