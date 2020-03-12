//
//  LaunchCarousel.swift
//  TripList
//
//  Created by Julien Vanheule on 10/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI


struct LaunchCarousel: View {
    @ObservedObject var appState = AppState.shared
    @State var cguPresented = false
    @State var confidentialitePresented = false
    @State var currentPageIndex = 0

    var subviews = [
        UIHostingController(rootView: CarouselImage(imageString: "premium1.jpg")),
        UIHostingController(rootView: CarouselImage(imageString: "premium2.jpg")),
        UIHostingController(rootView: CarouselImage(imageString: "premium4.jpg"))
    ]
    
    var titles = ["Bienvenue !", "Votre liste", "Progression"]
    
    var captions =  [
        "Découvrez notre sélection de destinations pour découvrir la France.\nMusées, patrimoine, village, nature, événements et sorties",
        "Ajoutez vos envies de voyages à votre liste\net préparez vos futures vacances",
        "Marquez les lieux visités et regardez ce qu'il reste à explorer"
    ]
    
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
            
            
            
            
            PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
            
            
            VStack(spacing: 10) {
                Text(titles[currentPageIndex])
                    .font(.title)
                    //.frame(height: 50)
                
                Text(captions[currentPageIndex]).multilineTextAlignment(.center)
                    //.frame(height: 100)
                
                if(self.currentPageIndex+1 == self.subviews.count){
                    VStack(spacing: 0) {
                        Text("En continuant vous acceptez nos")
                        HStack {
                            Button(action: {self.cguPresented.toggle()}) {
                                Text("CGU").foregroundColor(.blue)
                            }.sheet(isPresented: self.$cguPresented, content: {
                                WebViewModal(title: "Conditions générales", url: "https://www.apple.com")//TODO
                            })
                            Text("et la")
                            Button(action: {self.confidentialitePresented.toggle()}) {
                                Text("Politique de confidentialité").foregroundColor(.blue)
                            }.sheet(isPresented: self.$confidentialitePresented, content: {
                                WebViewModal(title: "Confidentialité", url: "https://www.apple.com")//TODO
                            })
                        }
                    }
                    
                }
                
                PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                
                Rectangle().opacity(0).frame(height: 100)
            }
            .padding()
            .background(BlurView(style: .systemUltraThinMaterial))
            .cornerRadius(15)
            .padding(.bottom, -20)
            .frame(minWidth: 300, maxWidth: 600, minHeight: 100, maxHeight: .infinity, alignment: Alignment.bottom)
                
            
            
            Button(action: {
                if self.currentPageIndex+1 == self.subviews.count {
                    self.appState.acceptCGU()
                } else {
                    self.currentPageIndex += 1
                }
            }) {
                if(self.currentPageIndex+1 == self.subviews.count) {
                    Text("Accepter")
                        .fontWeight(.semibold)
                        .font(.headline).foregroundColor(.white)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(.white)
                        .background(Color.green)
                        //.background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: 0x59D722)), Color(UIColor(hex: 0x105800))]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(20)
                } else {
                   Text("Continuer")
                       .fontWeight(.semibold)
                       .font(.headline).foregroundColor(.white)
                       .frame(width: 250.0, height: 40.0)
                       .foregroundColor(.white)
                    .background(Color.blue)
                    //.background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex:0x3AB9E4)), Color(UIColor(hex:0x1A16C1))]), startPoint: .top, endPoint: .bottom))
                       .cornerRadius(20)
                }
            }.padding(70)
            
            
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct LaunchCarousel_Previews: PreviewProvider {
    static var previews: some View {
        LaunchCarousel()
    }
}
#endif


struct CarouselImage: View {
    var imageString: String
    
    var body: some View {
        GeometryReader { geometry in
            ImageStore.shared.image(name: self.imageString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .imageScale(.large)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
    }
}


struct WebViewModal: View {
    var title: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model: WebViewModel
    
    let dg = DragGesture()
     
    init(title: String, url: String){
        var stringUrl = url
        if !url.hasPrefix("http"){
            stringUrl = "https://"+url
        }
        self.title = title
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
