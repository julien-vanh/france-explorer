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
        UIHostingController(rootView: CarouselImage(imageString: "launchcarousel1.jpg")),
        UIHostingController(rootView: CarouselImage(imageString: "launchcarousel2.jpg")),
        UIHostingController(rootView: CarouselImage(imageString: "launchcarousel3.jpg"))
    ]
    
    var titles = [
        NSLocalizedString("Bienvenue !", comment: ""),
        NSLocalizedString("Nos catégories", comment: ""),
        NSLocalizedString("Organisez votre voyage", comment: ""),
    ]
    
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
            
            PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
            
            
            VStack(spacing: 10) {
                Text(titles[currentPageIndex])
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                
                if currentPageIndex == 0 {
                    Text("Ce guide vous permettra de décrouvrir les plus belles destinations touristiques de France.")
                        .multilineTextAlignment(.center)
                }
                
                
                
                else if currentPageIndex == 1 {
                    HStack(alignment: .center, spacing: 0) {
                        
                        ForEach(PlaceStore.shared.getCategoriesWithoutAll(), id: \.title) { cat in
                            Image("\(cat.category.rawValue)-white")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .padding(6)
                                .background(Color(AppStyle.color(for: cat.category)))
                                .cornerRadius(10)
                                .padding(4)
                        }
                    }
                    
                    Text("Villes, Musées, Nature, Patrimoine, Sorties pour voyager selon vos envies.")
                        .multilineTextAlignment(.center)
                }
 
                
                else if currentPageIndex == 2 {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "text.badge.plus")
                            .font(.largeTitle)
                            .frame(width: 35, height: 35)
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Text("Ajoutez les destinations à votre prochain Voyage.")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .frame(width: 35, height: 35)
                            .padding(10)
                            .background(Color(UIColor.explored))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Text("Marquez les destinations explorées.")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "text.badge.checkmark")
                            .font(.largeTitle)
                            .frame(width: 35, height: 35)
                            .padding(10)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        
                        Text("Collectionnez les lieux explorés de chaque région.")
                            .font(.headline)
                        
                        Spacer()
                    }
                }
                
                
                if (self.currentPageIndex+1 == self.subviews.count){
                    VStack(spacing: 0) {
                        Text("En continuant vous acceptez notre")
                        
                        Button(action: {self.cguPresented.toggle()}) {
                            Text("Politique de confidentialité").underline()
                        }.sheet(isPresented: self.$cguPresented, content: {
                            WebViewModal(title: "Politique de confidentialité", url: Locale.current.languageCode == "fr" ? "https://www.france-explorer.fr/confidentialite-fr.html" : "https://www.france-explorer.fr/confidentialite.html")
                        }).buttonStyle(PlainButtonStyle())
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
                        .font(.headline)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(.white)
                        .background(Color.green)
                        //.background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex: 0x59D722)), Color(UIColor(hex: 0x105800))]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(20)
                } else {
                   Text("Continuer")
                       .fontWeight(.semibold)
                       .font(.headline)
                       .frame(width: 250.0, height: 40.0)
                       .foregroundColor(.white)
                        //.background(Color.blue)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hex:0x005BBF)), Color(UIColor(hex:0x007AFF))]), startPoint: .leading, endPoint: .trailing))
                       .cornerRadius(20)
                }
            }.padding(.bottom, 70)
            
            
        }
        .edgesIgnoringSafeArea(.all)
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
            ImageStore.shared.localImage(name: self.imageString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .imageScale(.large)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }.edgesIgnoringSafeArea(.all)
    }
}
