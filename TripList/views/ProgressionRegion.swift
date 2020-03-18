//
//  ProgressionRegion.swift
//  TripList
//
//  Created by Julien Vanheule on 08/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import WaterfallGrid
import URLImage


struct ProgressionRegion: View {
    var region: PlaceRegion
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        WaterfallGrid(self.getCards(), id: \.id) { card in
            VStack {
                if card.type == .premiumCell {
                    PlaceCardLocked(card: card)
                } else {
                    PlaceCard(card: card)
                }
            }
        }.gridStyle(
            columnsInPortrait: UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3,
            columnsInLandscape: UIDevice.current.userInterfaceIdiom == .phone ? 3 : 3
        )
            //.background(Color(UIColor.))
        .padding(.horizontal, 5)
        .navigationBarTitle(Text(self.region.name))
    }
    
    private func getCards() -> [ProgressionCard]{
        let places = PlaceStore.shared.getAllForRegion(regionId: self.region.id).sorted { (p1, p2) -> Bool in
            p1.category.rawValue < p2.category.rawValue
        }
        
        var result: [ProgressionCard] = []
        var premiumCount = 0
        
        places.forEach { (place) in
            if place.iap && !appState.isPremium {
                premiumCount += 1
            } else {
                result.append(ProgressionCard(place: place))
            }
        }
        
        if premiumCount > 0 {
            result.insert(ProgressionCard(premiumWithMissing: premiumCount), at: 4)
        }
        
        return result

    }
}

struct ProgressionRegion_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionRegion(region: regionsData[0])
    }
}

struct ProgressionCard: Identifiable {
    enum ProgressionCardType {
        case placeCell
        case premiumCell
    }
    var id: String
    var type: ProgressionCardType
    var place: Place!
    var missingPlacesCount: Int!
    
    init(premiumWithMissing: Int){
        id = "premium"
        type = .premiumCell
        missingPlacesCount = premiumWithMissing
    }
    
    init(place: Place){
        id = place.id
        type = .placeCell
        self.place = place
    }
}


struct PlaceCardLocked: View {
    var card: ProgressionCard
    @State private var isPurchasePresented: Bool = false

    var body: some View {
        Button(action: {self.isPurchasePresented.toggle()}) {
            ZStack(alignment: .bottomLeading) {
                ImageStore.shared.image(name: "placeholder.jpg")//TODO
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .renderingMode(.original)
                        .foregroundColor(Color.yellow)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                    
                    Text("Guide complet")
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.yellow)
                    
                    Spacer()
                }
                .padding(5.0)
            }
        }
            /*
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.yellow, lineWidth: 3)
        )*/
        //.cornerRadius(10)
        .sheet(isPresented: self.$isPurchasePresented, content: {
            PurchasePage()
        })

    }
}

struct PlaceCard: View {
    var card: ProgressionCard
    
    var fetchRequest: FetchRequest<Completion>
    var completions: FetchedResults<Completion> { fetchRequest.wrappedValue }

    init(card: ProgressionCard){
        self.card = card
        fetchRequest = FetchRequest<Completion>(entity: Completion.entity(), sortDescriptors: [], predicate: NSPredicate(format: "placeId == %@", card.place!.id))
    }
    
    var body: some View {
        NavigationLink(destination: LazyView(PlaceDetail(place: self.card.place!, displayAssociates: false))){
            VStack(alignment: .center, spacing: 0) {
                
                ImageStore.shared.image(forPlace: card.place!)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .grayscale((self.completions.first != nil) ? 0.0 : 0.99)
                    .blur(radius: (self.completions.first != nil) ? 0.0 : 1)
                    .clipped()
                
                HStack(alignment: .center, spacing: 10) {
                    /*
                    Image("\(card.place!.category)-colored")
                        .resizable()
                        .renderingMode(.original)
                        
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
 */
                    Spacer()
                    Text(card.place!.title)
                        .foregroundColor(Color(AppStyle.color(for: self.card.place!.category)))
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                }
                .padding(5.0)
                //.background(BlurView(style: .dark))
                .background(Color.white)
            }.overlay(
                Rectangle()
                    .strokeBorder(Color(UIColor.systemGray2), lineWidth: 1)
            )
            //.cornerRadius(10)
        }
    }
}
