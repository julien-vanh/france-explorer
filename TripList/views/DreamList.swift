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
    @State private var showingAlert = false
    @State private var alertErrorMessage = ""
    @State private var showingActionSheet = false
    @State private var showingPopover = false
    @Environment(\.editMode) var mode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Dream.getAllDreams()) var dreams: FetchedResults<Dream>
    @State private var isSharePresented: Bool = false
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Ma Liste"), buttons: [
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
            .navigationBarTitle("Ma liste")
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
                }
                .popover(isPresented: $showingPopover, arrowEdge: .bottom){
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
            ))
        }
        .sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            ActivityViewController(activityItems: self.sharedItems())
        })
        .actionSheet(isPresented: $showingActionSheet) {
            self.actionSheet
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Erreur"), message: Text(alertErrorMessage), dismissButton: .default(Text("OK")))
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
            self.alertErrorMessage = error.localizedDescription
            self.showingAlert = true
        }
    }
    
    private func copyInReminder(){
        showingPopover = false
        let dreamsArray = self.dreams.map { (dream) -> Dream in
            return dream
        } // car self.dreams n'est pas un array
        Reminders.copyDreams(dreams: dreamsArray, completion: { success, error in
            if error != nil {
                self.alertErrorMessage = error!.localizedDescription
                self.showingAlert = true
            }
        })
    }
    
    private func share(){
        showingPopover = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {//Retadé de 1 sec pour attendre que le popover dismiss
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
