//
//  Parameters.swift
//  TripList
//
//  Created by Julien Vanheule on 01/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct Parameters: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            List {
                
                
                Section(header: Text("Synchonisation"), content: {
                    HStack {
                        Image(systemName: "arrow.clockwise.icloud").foregroundColor(.blue).frame(width:30)
                        Text("iCloud")
                    }
                })
                
                
                Section(header: Text("Applications"), content: {
                    HStack {
                        Image(systemName: "star").foregroundColor(.yellow).frame(width:30)
                        Text("Noter l'application")
                    }
                    HStack {
                        Image(systemName: "square.and.pencil").foregroundColor(.green).frame(width:30)
                        Text("Nous contacter")
                    }
                    HStack {
                        Image(systemName: "square.and.arrow.up").foregroundColor(.red).frame(width:30)
                        Text("Partager")
                    }
                })
                
                
                
                
                Section(header: Text("À propos"), footer: Footer(), content: {
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(UIApplication.appVersion).foregroundColor(.blue)
                    }
                    
                    Text("Confidentialité")
                    
                    Text("Mentions tierces")
                })
                
                
                
                
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Paramètres", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("OK") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.environment(\.horizontalSizeClass, .compact)
    }
}

struct Parameters_Previews: PreviewProvider {
    static var previews: some View {
        Parameters()
    }
}

struct Footer: View {
    var body: some View {
            Text("TripList\n @2020 ForgeApp Studio. Tous droits réservés.")
                .foregroundColor(.gray)
                .font(.footnote)
    }
}

extension UIApplication {
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
