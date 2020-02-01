//
//  DreamList.swift
//  LifeList
//
//  Created by Julien Vanheule on 18/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct DreamList: View {
    @EnvironmentObject private var session: Session
    @State private var showingSheet = false
    @State private var showAddRow = false
    @Environment(\.editMode) var mode
    
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
                ForEach(session.dreams, id: \.self) { dream in
                    NavigationLink(
                        destination: DreamDetail(dream: dream)
                    ) {
                        DreamListRow(dream: dream)
                    }
                }.onDelete(perform: deleteRow).onMove(perform: move)
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
        }//.accentColor( .white)
    }
    
    private func deleteRow(at indexSet: IndexSet) {
        self.session.dreams.remove(atOffsets: indexSet)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        self.session.dreams.move(fromOffsets: source, toOffset: destination)
    }
}

struct DreamList_Previews: PreviewProvider {
    static var previews: some View {
        DreamList().environmentObject(Session())
    }
}
