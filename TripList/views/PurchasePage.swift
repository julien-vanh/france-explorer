//
//  PurchasePage.swift
//  TripList
//
//  Created by Julien Vanheule on 02/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//
import SwiftUI

struct PurchasePage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                
                PurchaseCarousel()
                
                Text("Ne passez pas à coté de l'inmanquable.\nDéverouillez l'intégralité de l'application.")
                    .padding()
                    .foregroundColor(.gray)
                
                FeatureLine(text: "300 lieux supplémentaires en France")
                FeatureLine(text: "Régions d'outre-mer")
                FeatureLine(text: "Suppression de la publicité")
                FeatureLine(text: "Liste illimitée")
                
                PurchaseButtons().padding()
                
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Version complète", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("OK") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }.environment(\.horizontalSizeClass, .compact)
    }
}

struct PurchasePage_Previews: PreviewProvider {
    static var previews: some View {
        PurchasePage()
    }
}

struct PurchaseCarousel: View {
    let images: [String] = [
        "premium1.jpg",
        "premium2.jpg",
        "premium3.jpg",
        "premium4.jpg",
        "premium5.jpg"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ImageCarouselView(numberOfImages: self.images.count) {
                ForEach(self.images, id: \.self) { image in
                    ImageStore.shared.image(name: image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width-20, height:geometry.size.height)
                        .clipped().cornerRadius(15).padding(10)
                }
            }
        }.frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
    }
}

struct FeatureLine: View {
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "plus").foregroundColor(.yellow)
            Text(text)
            Spacer()
        }.padding(.horizontal, 20)
    }
}

struct PurchaseButtons: View {
    var price:String = "Acheter 4,99 €"
    
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                print("purchasing...")
            }) {
                Text(price)
                    .fontWeight(.semibold)
                    .font(.headline).foregroundColor(.white)
                    .frame(width: 250.0, height: 40.0)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(20)
            }
            
            SeparationBar()
                
            Button(action: {
                print("Restauring")
            }) {
                Text("Restaurer mes achats")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(width: 250.0, height: 40.0)
            }
        }
    }
}
