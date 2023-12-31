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
    @State private var showingActionSheet = false
    @State private var showingPopover = false
    @Environment(\.editMode) var mode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Dream.getAllDreams()) var dreams: FetchedResults<Dream>
    @State private var isSharePresented: Bool = false
    @ObservedObject var appState = AppState.shared
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Mon Voyage"), buttons: [
            .default(Text("Copier dans Rappels"), action:copyInReminder),
            //.default(Text("Imprimer"), action:{}),
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
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Mon Voyage"))
            .navigationBarItems(leading:EditButton(), trailing:(
                Button(action: {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        self.showingActionSheet = true
                    } else {
                        self.showingPopover = true
                    }
                }){
                    Image(systemName: "ellipsis.circle.fill")
                        .frame(width: 100, height: 40, alignment: .trailing)
                        .font(.title)
                    .popover(isPresented: $showingPopover, arrowEdge: .top){
                        List {
                            Button(action: self.copyInReminder) {
                                Text("Copier dans Rappels").foregroundColor(.blue)
                            }
                            Button(action: self.share) {
                                Text("Partager").foregroundColor(.blue)
                            }
                            Button(action: self.deleteCompletes) {
                                Text("Supprimer les complétés").foregroundColor(.red)
                            }
                        }
                    }
                }
                
            ))
        }
        .sheet(isPresented: $isSharePresented, content: {
            ActivityViewController(activityItems: self.sharedItems())
        })
        .actionSheet(isPresented: $showingActionSheet) {
            self.actionSheet
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteRow(at indexSet: IndexSet) {
        let item = dreams[indexSet.first!]
        managedObjectContext.delete(item)
        saveDreams()
    }
    
    private func move(from indexSet: IndexSet, to destination: Int) {
        let source = indexSet.first!
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = dreams[source].order
            while startIndex <= endIndex {
                dreams[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            
            dreams[source].order = startOrder
            
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = dreams[destination].order + 1
            let newOrder = dreams[destination].order
            while startIndex <= endIndex {
                dreams[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            dreams[source].order = newOrder
        }
        
        saveDreams()
    }
    
    private func saveDreams(){
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
            self.appState.displayError(error: error)
        }
    }
    
    private func copyInReminder(){
        showingPopover = false
        let dreamsArray = self.dreams.compactMap {($0)}
        Reminders.copyDreams(dreams: dreamsArray, completion: { success, error in
            if let error = error {
                self.appState.displayError(error: error)
            }
        })
    }
    
    private func share(){
        showingPopover = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {//Retardé de 1 sec pour attendre que le popover dismiss
            self.isSharePresented.toggle()
        }
        
    }
    
    private func sharedItems() -> [Any] {
        var items: [String] = []
        self.dreams.forEach({ (dream) in
            items.append(dream.title!)
        })
        return items;
    }
    
    private func deleteCompletes(){
        showingPopover = false
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
