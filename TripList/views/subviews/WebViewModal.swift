//
//  WebViewModal.swift
//  TripList
//
//  Created by Julien Vanheule on 19/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI


struct WebViewModal: View {
    var title: LocalizedStringKey
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model: WebViewModel
    
    let dg = DragGesture()
     
    init(title: String, url: String){
        var stringUrl = url
        if !url.hasPrefix("http"){
            stringUrl = "https://"+url
        }
        self.title = LocalizedStringKey(title)
        self.model = WebViewModel(url: stringUrl)
    }
     
    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$model.isLoading) {
                WebView(viewModel: self.model)
            }
            .highPriorityGesture(self.dg)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Fermer") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.environment(\.horizontalSizeClass, .compact)
    }
}

/*
struct WebViewModal_Previews: PreviewProvider {
    static var previews: some View {
        WebViewModal(title: "Titre de la webview")
    }
}
*/
