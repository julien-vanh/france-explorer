//
//  DreamList.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct DreamList: View {
    @State private var showingSheet = false
    @Environment(\.editMode) var mode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Dream.getAllDreams()) var dreams: FetchedResults<Dream>

    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Ma Liste"), buttons: [
            .default(Text("Copier dans Rappels")),
            .default(Text("Imprimer")),
            .default(Text("Partager")),
            .destructive(Text("Annuler"))
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
            .navigationBarItems(leading:(
                    Button(action: {
                        self.showingSheet = true
                    }){
                        Image(systemName: "square.and.arrow.up.fill")
                            .frame(width: 100, height: 40, alignment: .leading)
                    }.actionSheet(isPresented: $showingSheet) {
                        self.actionSheet
                    }
                ), trailing: EditButton()
            )
        }
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
}

struct DreamList_Previews: PreviewProvider {
    static var previews: some View {
        DreamList()
    }
}
