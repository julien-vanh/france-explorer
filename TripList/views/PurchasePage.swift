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
    @ObservedObject var appState = AppState.shared

    
    var body: some View {
        VStack() {
        
            //Text("Boutique").font(.title).padding(.vertical, 20)
            
            PurchaseCarousel()//.padding(.top, -50)
                    
            ForEach(productsStore.products, id: \.self) { prod in
                VStack {
                    if prod.productIdentifier == ProductsStore.ProductGuideFrance {
                        
                        Text(prod.localizedTitle).font(.largeTitle).multilineTextAlignment(.center).foregroundColor(.yellow)
                          
                        FeatureLine(text: NSLocalizedString("Le guide complet contient 350 destinations supplémentaires.", comment:""))
                        FeatureLine(text: NSLocalizedString("Liste des destinations 100% hors-ligne.", comment:""))
                        
                                
                        PurchaseButton(block: {
                            self.purchaseProduct(skproduct: prod)
                        }, product: prod).padding(.top, 20)
                    }
                }
            }
            
            SeparationBar()
                .padding(.horizontal, 50)
                .padding(.vertical, 20)
                
            Button(action: {
                self.restorePurchases()
            }) {
                Text("Restaurer mes achats")
                    .font(.subheadline)
            }
            
            
            Spacer()
        }
        .background(Color.black)
        
        .listStyle(GroupedListStyle())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Erreur"), message: Text(alertErrorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear(){
            self.productsStore.initializeProducts()
            
            Analytics.logEvent("PurchasePagePresented", parameters: nil)
        }
    }
    
    func restorePurchases(){
        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            self.productsStore.handleUpdateStore()
            self.appState.hideDrawer()
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
        print("Purchasing product: \(skproduct.productIdentifier)")
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            self.productsStore.handleUpdateStore()
            
            self.appState.hideDrawer()
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
        "premium2.jpg",
        "launchcarousel3.jpg",
        "premium1.jpg",
        "launchcarousel1.jpg",
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ImageCarouselView(numberOfImages: self.images.count) {
                ForEach(self.images, id: \.self) { image in
                    ImageStore.shared.localImage(name: image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height:geometry.size.height)
                        .clipped()//.cornerRadius(15).padding(10)
                }
            }
        }.frame(height: UIDevice.current.userInterfaceIdiom == .phone ? 330 : 390, alignment: .center)
    }
    
}

struct FeatureLine: View {
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "plus").foregroundColor(.yellow)
            Text(text).foregroundColor(.white)
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
            Text("Acheter \(product.localizedPrice)")
                .fontWeight(.semibold)
                .font(.headline).foregroundColor(.white)
                .frame(width: 300.0, height: 40.0)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(20)
        }.disabled(IAPManager.shared.isActive(productIdentifier: product.productIdentifier))
    }
}
