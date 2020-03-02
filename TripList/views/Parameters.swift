//
//  Parameters.swift
//  TripList
//
//  Created by Julien Vanheule on 01/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import MessageUI

struct Parameters: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSharePresented: Bool = false
    @State private var isPurchasePresented: Bool = false
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {self.isPurchasePresented.toggle()}) {
                    Text("Version complète")
                }
                .sheet(isPresented: $isPurchasePresented, onDismiss: {
                    print("Dismiss")
                }, content: {
                    PurchasePage()
                })
                
                Section(header: Text("Synchonisation"), content: {
                    Button(action: {
                        print("Syncing") //TODO
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise.icloud").foregroundColor(.blue).frame(width:30)
                            Text("iCloud")
                        }
                    }
                })
                
                
                Section(header: Text("Applications"), content: {
                    Button(action: {
                        AppState.openLinkInBrowser(link: "http://VERSLESTORE") //TODO
                    }) {
                        HStack {
                            Image(systemName: "star").foregroundColor(.yellow).frame(width:30)
                            Text("Noter l'application")
                        }
                    }
                    
                    
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil").foregroundColor(.green).frame(width:30)
                            Text("Nous contacter")
                        }
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                    }
                    
                    
                    Button(action: {self.isSharePresented.toggle()}) {
                        HStack {
                            Image(systemName: "square.and.arrow.up").foregroundColor(.red).frame(width:30)
                            Text("Partager")
                        }
                    }.sheet(isPresented: $isSharePresented, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityViewController(activityItems:["Connaisez-vous la France ?", "TripList", "LIEN VERS LE STORE"]) //TODO
                    })
                    
                })
                
                
                
                
                Section(header: Text("À propos"), footer: Footer(), content: {
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(UIApplication.appVersion).foregroundColor(.gray)
                    }
                    
                    Text("Confidentialité") //TODO NavigationLink
                    
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
