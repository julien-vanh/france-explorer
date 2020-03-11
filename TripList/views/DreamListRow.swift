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
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var dream: Dream
    var fetchRequest: FetchRequest<Completion>
    var completions: FetchedResults<Completion> { fetchRequest.wrappedValue }
    
    init(dream: Dream) {
        self.dream = dream
        fetchRequest = FetchRequest<Completion>(entity: Completion.entity(), sortDescriptors: [], predicate: NSPredicate(format: "placeId == %@", dream.placeId ?? 0))
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                self.toggle()
                
            }) {
                Image(systemName: self.dream.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color(UIColor.explored))
                    .font(.title)
            }.buttonStyle(BorderlessButtonStyle())
            
            Text(dream.title ?? "")
        }
    }
    
    private func toggle(){
        self.dream.completed.toggle()
        if(self.dream.completed){
            let completion = Completion(context: self.managedObjectContext)
            completion.configure(placeId: self.dream.placeId ?? "0")
            VibrationManager.shared.success()
        } else {
            self.completions.forEach({
                self.managedObjectContext.delete($0)
            })
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}
