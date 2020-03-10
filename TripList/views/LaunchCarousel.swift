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
    
    var titles = ["Take some time out", "Conquer personal hindrances", "Create a peaceful mind"]
    
    var captions =  ["Take your time out and bring awareness into your everyday life", "Meditating helps you dealing with anxiety and other psychic problems", "Regular medidation sessions creates a peaceful inner mind"]
    
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
            
            
            PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
            
            
            VStack(spacing: 10) {
                Text(titles[currentPageIndex])
                    .font(.title)
                    //.frame(height: 50)
                
                Text(captions[currentPageIndex])
                    //.frame(height: 100)
                
                if(self.currentPageIndex+1 == self.subviews.count){
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
                }
                
                PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                
                Rectangle().opacity(0).frame(height: 80)
            }
            .padding()
            .background(BlurView(style: .systemUltraThinMaterial))
            .cornerRadius(15)
            .padding(.bottom, -20)
            .frame(minWidth: 300, maxWidth: 600, minHeight: 100, maxHeight: .infinity, alignment: Alignment.bottom)
                
            
            
            Button(action: {
                if self.currentPageIndex+1 == self.subviews.count {
                    self.appState.displayLaunchCarousel = false
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
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                } else {
                   Text("Suivant")
                       .fontWeight(.semibold)
                       .font(.headline).foregroundColor(.white)
                       .frame(width: 250.0, height: 40.0)
                       .foregroundColor(.white)
                       .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue]), startPoint: .leading, endPoint: .trailing))
                       .cornerRadius(20)
                }
            }.padding(30)
            
            
        }.edgesIgnoringSafeArea(.top)
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
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
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
