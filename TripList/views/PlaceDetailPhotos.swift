//
//  PlaceDetailPhotos.swift
//  TripList
//
//  Created by Julien Vanheule on 30/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import ASCollectionView

struct PlaceDetailPhotos: View {
    var place: Place
    @State private var pageImages: [ImageMetadata] = []
    
    var body: some View {
        
        ASCollectionView(data: pageImages, dataID: \.self) { pageImage, _ in
            KFImage(pageImage.url).placeholder {
                // Placeholder while downloading.
                Image(systemName: "arrow.2.circlepath.circle")
                    .font(.largeTitle)
                    .opacity(0.3)
            }
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                
                .frame(width: 200.0, height: 200.0).clipped()
        }
        .layout {
            .grid(layoutMode: .adaptive(withMinItemSize: 150),
                  itemSpacing: 10,
                  lineSpacing: 10,
                  itemSize: .absolute(150))
        }
        .scrollIndicatorsEnabled(false)
        .navigationBarTitle(place.title)
        .edgesIgnoringSafeArea([.top, .horizontal])
        .onAppear(perform: {
            WikipediaService.shared.getPageImages(288657) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    self.pageImages = value
                }
            }
        })
    }
}

struct PlaceDetailPhotos_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailPhotos(place: PlaceStore.shared.get(id: "1"))
    }
}
