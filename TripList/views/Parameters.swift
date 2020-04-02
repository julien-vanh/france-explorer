//
//  Parameters.swift
//  TripList
//
//  Created by Julien Vanheule on 01/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//
let AppId = "1501849156"

import SwiftUI
import MessageUI

struct Parameters: View {
    @State private var isSharePresented: Bool = false
    @State private var cguPresented: Bool = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        NavigationView {
            List {
                if !appState.isPremium {
                    Button(action: {
                        self.appState.displayPurchasePageDrawer()
                    }) {
                        Text("Version complète")
                    }
                }
                
                /*
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
                */
                
                
                Section(header: Text("Application"), content: {
                    Button(action: {
                        Browser.openLinkInBrowser(link: "https://itunes.apple.com/app/id\(AppId)?action=write-review")
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
                    }.sheet(isPresented: $isSharePresented, content: {
                        ActivityViewController(activityItems:[
                            NSLocalizedString("Connaissez-vous bien la France ?", comment: ""),
                            NSLocalizedString("appname", comment: ""),
                            "https://itunes.apple.com/app/id\(AppId)"])
                    })
                    
                })
                
                
                
                
                Section(header: Text("À propos"), footer: AboutFooter(), content: {
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(UIApplication.appVersion).foregroundColor(.gray)
                    }
                    
                    
                    Button(action: {self.cguPresented.toggle()}) {
                        Text("Confidentialité")
                    }.sheet(isPresented: self.$cguPresented, content: {
                        WebViewModal(title: "Confidentialité", url: "https://www.france-explorer.fr/confidentialite.html")
                    })
                    
                    NavigationLink(destination: ThirdPartyLicencesList()){
                        Text("Mentions tierces").foregroundColor(.blue)
                    }
                })
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Paramètres"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}

struct Parameters_Previews: PreviewProvider {
    static var previews: some View {
        Parameters()
    }
}

struct AboutFooter: View {
    var body: some View {
        HStack {
            Spacer()
            Text("France Explorer\n @2020 Julien Vanheule. Tous droits réservés.")
            .foregroundColor(.gray)
                .font(.footnote).multilineTextAlignment(.center)
            Spacer()
        }
            
    }
}

extension UIApplication {
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
