//
//  PurchasePage.swift
//  TripList
//
//  Created by Julien Vanheule on 02/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//
import SwiftUI
import StoreKit
import FirebaseAnalytics


struct PurchasePage: View {
    @State private var showingAlert = false
    @State private var alertErrorMessage = ""
    @ObservedObject var productsStore : ProductsStore = ProductsStore.shared
    @State private var isDisabled : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                
                PurchaseCarousel()
                
                Text("Ne passez pas à coté de l'inmanquable.\nDéverouillez l'intégralité de l'application.")
                    .padding()
                    .foregroundColor(.gray)
                
                FeatureLine(text: "350 destinations supplémentaires")
                //FeatureLine(text: "Régions d'outre-mer")
                FeatureLine(text: "Suppression de la publicité")
                FeatureLine(text: "Liste illimitée")
                
                
                VStack(alignment: .center) {
                    ForEach(productsStore.products, id: \.self) { prod in
                        HStack {
                            if prod.productIdentifier == ProductsStore.ProductGuideFrance {
                                PurchaseButton(block: {
                                    self.purchaseProduct(skproduct: prod)
                                }, product: prod)
                                    .disabled(IAPManager.shared.isActive(productIdentifier: prod.productIdentifier))
                            }
                        }
                        
                    }
                    
                    SeparationBar()
                        
                    Button(action: {
                        self.restorePurchases()
                    }) {
                        Text("Restaurer mes achats")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .frame(width: 250.0, height: 40.0)
                    }
                }.padding()
                
            }
            .listStyle(GroupedListStyle())
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Erreur"), message: Text(alertErrorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle(Text("Version complète"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button("OK") {
                    self.dismiss()
                }
            )
        }
        .environment(\.horizontalSizeClass, .compact)
        .onAppear(){
            self.productsStore.initializeProducts()
            
            Analytics.logEvent("PurchasePagePresented", parameters: nil)
        }
    }
    
    
    
    func restorePurchases(){
        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            self.productsStore.handleUpdateStore()

            self.dismiss()
        }) { (error) in
            self.isDisabled = false
            self.productsStore.handleUpdateStore()
            
            if let error = error {
                self.alertErrorMessage = error.localizedDescription
            } else {
                self.alertErrorMessage = ""
            }
            self.showingAlert = true
        }
    }
    
    func purchaseProduct(skproduct : SKProduct){
        print("did tap purchase product: \(skproduct.productIdentifier)")
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            self.productsStore.handleUpdateStore()
            
            self.dismiss()
        }) { (error) in
            self.isDisabled = false
            self.productsStore.handleUpdateStore()
            
            if let error = error {
                self.alertErrorMessage = error.localizedDescription
            } else {
                self.alertErrorMessage = ""
            }
            self.showingAlert = true
        }
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
        }.frame(height: 280, alignment: .center)
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

struct PurchaseButton : View {
    var block : SuccessBlock!
    var product : SKProduct!

    var body: some View {
        Button(action: {
            self.block()
        }) {
            Text(product.localizedPrice)
                .fontWeight(.semibold)
                .font(.headline).foregroundColor(.white)
                .frame(width: 250.0, height: 40.0)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(20)
        }
    }
}
