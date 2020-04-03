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
            columnsInLandscape: UIDevice.current.userInterfaceIdiom == .phone ? 3 : 4
        )
            //.background(Color(UIColor.))
        .padding(.horizontal, 5)
        .navigationBarTitle(Text(self.region.name))
    }
    
    private func getCards() -> [ProgressionCard]{
        let places = PlaceStore.shared.getAllForRegion(regionId: self.region.id).sorted { (p1, p2) -> Bool in
            p1.popularity > p2.popularity
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
    @ObservedObject private var appState = AppState.shared

    var body: some View {
        Button(action: {
            self.appState.displayPurchasePageDrawer()
        }) {
            ZStack(alignment: .center) {
                
                ImageStore.shared.image(name: "premium0.jpg")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                
                VStack(alignment: .leading) {
                    Text("Guide complet")
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .fontWeight(.semibold)
                        .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                        
                    
                    Text("\(card.missingPlacesCount!) " + NSLocalizedString("destinations supplémentaires dans cette région", comment:""))
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .shadow(color: Color.black, radius: 15, x: 0, y: 0)
                }.padding(10)
                
                
            }.overlay(
                Rectangle()
                    .strokeBorder(Color.yellow, lineWidth: 2)
            )
        }
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
                    .blur(radius: (self.completions.first != nil) ? 0.0 : 3)
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
                    Text(card.place!.titleLocalized)
                        .foregroundColor((self.completions.first != nil) ? Color(AppStyle.color(for: self.card.place!.category)) : Color.gray)
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
