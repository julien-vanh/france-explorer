//
//  CreditsModal.swift
//  TripList
//
//  Created by Julien Vanheule on 05/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct CreditsModal: View {
    var place: Place
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
                if place.illustration != nil {
                    Text("Photo")
                    Text(place.illustration!.description).foregroundColor(.gray)
                    Text(place.illustration!.credit).foregroundColor(.gray)
                    Text(place.illustration!.source).foregroundColor(.gray)
                    .padding(.bottom, 30.0)
                }
                
                if (self.place.descriptionLocalized != nil){
                    Text("Texte")
                    Text(self.place.descriptionLocalized!.credit).foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text("Crédits"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button("OK") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.environment(\.horizontalSizeClass, .compact)
        
    }
}
