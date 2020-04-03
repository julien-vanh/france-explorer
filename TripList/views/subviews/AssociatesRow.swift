//
//  AssociatedHintsRow.swift
//  LifeList
//
//  Created by Julien Vanheule on 24/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct AssociatesRow: View {
    @Binding var place: Place
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
       VStack(alignment: .leading) {
            Text("Découvrez aussi")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(PlaceStore.shared.getAssociatedPlaceTo(place: place, count: 6, premium: appState.isPremium)) { place in
                        
                        NavigationLink(destination: PlaceDetail(place: place, displayAssociates: false )){
                            ZStack {
                                ImageStore.shared.image(forPlace: place)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped().frame(width: 155, height: 155)
                                
                                Text(place.titleLocalized)
                                    .fontWeight(.semibold)
                                    .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                                    .foregroundColor(.white).frame(width: 155, height: 155)
                                    .multilineTextAlignment(.center)
                            }
                            .cornerRadius(5)
                            .padding(.leading, 15)
                        }
                    }
                }
            }
            .frame(height: 155)
        }
    }
}

struct AssociatedHintsRow_Previews: PreviewProvider {
    static var previews: some View {
        AssociatesRow(place: Binding(.constant(PlaceStore.shared.getRandom(count: 1, premium: false)[0]))!)
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
