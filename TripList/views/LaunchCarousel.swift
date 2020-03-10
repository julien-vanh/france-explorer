//
//  LaunchCarousel.swift
//  TripList
//
//  Created by Julien Vanheule on 10/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI


struct LaunchCarousel: View {
    @State var currentIndex = 0
    @ObservedObject var appState = AppState.shared
    @State var cguPresented = false
    @State var confidentialitePresented = false
    
    var pages = [
        LaunchPage(
            image: "premium1.jpg",
            title: "Bienvenue !",
            text: "Des centaines d’idées voyage pour découvrir la France\nMusées, patrimoine, village, nature, événement et sorties"
        ),
        LaunchPage(
            image: "premium2.jpg",
            title: "Carte",
            text: "Pour rechercher les points d’intérêts à proximité.\nL’occasion d’un détour pour ne rien rater"
        ),
        /*
        LaunchPage(
            image: "premium1.jpg",
            title: "Votre liste",
            text: "Pour ajouter vos futures destinations et préparer votre voyage "
        ),
 */
        LaunchPage(
            image: "premium4.jpg",
            title: "Progression",
            text: "Marquer les lieux visités.\nPermet de déterminer quelles régions sont inexplorées "
        )
    ]
    
    
    
    var body: some View {
        ZStack {
            Color.white
            
            PageView(self.pages, currentPage: self.$currentIndex)
            
            
            VStack(spacing: 10) {
                /*
                HStack(spacing: 3) {
                    ForEach(0..<self.pages.count, id: \.self) { index in
                        Circle()
                            .frame(width: 10, height: 10)
                            //.foregroundColor(index == self.currentIndex ? Color.blue : .white)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 8)
                            .animation(.spring())
                    }
                }
                */
                
                
                VStack {
                    
                        //if self.currentIndex == (self.pages.count-1) {
                            HStack {
                                Button(action: {self.cguPresented.toggle()}) {
                                    Text("CGU").foregroundColor(.blue)
                                }.sheet(isPresented: self.$cguPresented, content: {
                                    WebViewModal(title: "Conditions générales", url: "https://www.apple.com")
                                })
                                Text("et la")
                                Button(action: {self.confidentialitePresented.toggle()}) {
                                    Text("Politique de confidentialité").foregroundColor(.blue)
                                }.sheet(isPresented: self.$confidentialitePresented, content: {
                                    WebViewModal(title: "Confidentialité", url: "https://www.apple.com")
                                })
                            }
                        //}
                        
                        
                        Button(action: {
                            if self.currentIndex == (self.pages.count-1) {
                                self.appState.displayLaunchCarousel = false
                            } else {
                                self.currentIndex += 1
                            }
                        }) {
                            Text(self.currentIndex == (self.pages.count-1) ? "Accepter" : "Suivant")
                                .fontWeight(.semibold)
                                .font(.headline).foregroundColor(.white)
                                .frame(width: 250.0, height: 40.0)
                                .foregroundColor(.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(20)
                        }.padding(.bottom, 50)
                        
                    Text("LOL")
                    }
                    .frame(height: 150, alignment: .bottom)
                    .background(BlurView(style: .systemUltraThinMaterial))
                }
                
            
        }
        
        .edgesIgnoringSafeArea(.top)
        
    }
}



struct LaunchCarousel_Previews: PreviewProvider {
    static var previews: some View {
        LaunchCarousel()
    }
}

struct LaunchPage: View {
    var image: String
    var title: String
    var text: String
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.white
            
            ImageStore.shared.image(name: self.image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Text(text)
            }
        }
    }
}


struct WebViewModal: View {
    var title: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model: WebViewModel
    
    init(title: String, url: String){
        self.title = title
        self.model = WebViewModel(url: url)
    }
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$model.isLoading) {
                WebView(viewModel: self.model)
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Fermer") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.environment(\.horizontalSizeClass, .compact)
    }
}
