//
//  DreamList.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import EventKit

struct DreamList: View {
    @State private var showingSheet = false
    @Environment(\.editMode) var mode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Dream.getAllDreams()) var dreams: FetchedResults<Dream>
    @State private var isSharePresented: Bool = false
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Ma Liste"), buttons: [
            .default(Text("Copier dans Rappels"), action:copyInReminder),
            //.default(Text("Imprimer"), action:printAsPdf),
            .default(Text("Partager"), action:share),
            .destructive(Text("Supprimer les complétés"), action:deleteCompletes),
            .cancel()
        ])
    }
    
    var body: some View {
        NavigationView(){
            List {
                ForEach(dreams) { dream in
                    NavigationLink(
                        destination: DreamDetail(dream: dream)
                    ) {
                        DreamListRow(dream: dream)
                    }
                }
                .onDelete(perform: deleteRow)
                .onMove(perform: move)
            }
            .navigationBarTitle("Ma liste")
            .navigationBarItems(leading:EditButton(), trailing:(
                Button(action: {
                    self.showingSheet = true
                }){
                    Image(systemName: "ellipsis.circle.fill")
                        .frame(width: 100, height: 40, alignment: .trailing)
                        .font(.title)
                }.actionSheet(isPresented: $showingSheet) {
                    self.actionSheet
                }
            ))
        }
        .sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            ActivityViewController(activityItems: self.sharedItems())
        })
    }
    
    private func deleteRow(at indexSet: IndexSet) {
        let item = dreams[indexSet.first!]
        managedObjectContext.delete(item)
        saveDreams()
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        var copyArray = Array(dreams)
        copyArray.move(fromOffsets: source, toOffset: destination)
        copyArray.enumerated().forEach { $1.order = $0 }
        saveDreams()
    }
    
    private func saveDreams(){
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
            //TODO afficher une popup
        }
    }
    
    private func copyInReminder(){
        let dreamsArray = self.dreams.map { (dream) -> Dream in
            return dream
        } // car self.dreams n'est pas un array
        Reminders.copyDreams(dreams: dreamsArray)
    }
    
    private func printAsPdf(){
        //TODO
    }
    
    private func share(){
        self.isSharePresented.toggle()
    }
    
    private func sharedItems() -> [Any] {
        var items: [String] = []
        self.dreams.forEach({ (dream) in
            items.append(dream.title!)
        })
        return items;
    }
    
    private func deleteCompletes(){
        dreams.forEach { (dream) in
            if dream.completed {
                managedObjectContext.delete(dream)
            }
        }
        saveDreams()
    }
}

struct DreamList_Previews: PreviewProvider {
    static var previews: some View {
        DreamList()
    }
}
