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
    @State private var showModal: Bool = false
    @State var selectedPageImage: ImageMetadata?
    
    var body: some View {
        
        ASCollectionView(data: pageImages, dataID: \.self) { pageImage, _ in
            GeometryReader { geometry in
                Button(action: {
                    self.selectedPageImage = pageImage
                    self.showModal.toggle()
                }, label: {
                    KFImage(pageImage.url).placeholder {
                        // Placeholder while downloading.
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .opacity(0.3)
                    }
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                })
                
                
            }.clipped()
        }
        .layout {
            .grid(layoutMode: .adaptive(withMinItemSize: 150),
                  itemSpacing: 10,
                  lineSpacing: 10,
                  itemSize: .absolute(150))
        }
        .scrollIndicatorsEnabled(false)
        .navigationBarTitle(Text(place.title), displayMode: .inline)
        .sheet(isPresented: $showModal, content: {
            ZStack {
                PhotoPager(photos: self.pageImages, initiale: self.selectedPageImage!)
                
                HStack {
                    VStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .background(
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 40, height: 40)
                        )
                        .frame(width: 40, height: 40)
                        .padding([.top, .leading], 20.0)
                        .onTapGesture {
                            self.showModal.toggle()
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }.background(Color.black).edgesIgnoringSafeArea(.bottom)
        })
        .onAppear(perform: {
            if let wikiPageId = self.place.wikiPageId {
                WikipediaService.shared.getPageImages(wikiPageId) { result in //TODO id en dur
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let value):
                        self.pageImages = value
                    }
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

struct PhotoPager: View {
    var photosViews: [PhotoFullscreen]
    @State private var index: Int
    
    init(photos: [ImageMetadata], initiale: ImageMetadata){
        self.photosViews = photos.map { PhotoFullscreen(pageImage: $0) }
        _index = State(initialValue: photos.firstIndex(where: {$0.title == initiale.title}) ?? 0)
    }
    
    var body: some View {
        PageView(photosViews, currentPage: $index)
            .edgesIgnoringSafeArea(.all)
    }
}

struct PhotoFullscreen: View {
    
    var pageImage: ImageMetadata
    
    var body: some View {
        ZStack {
            Color.black
            
            KFImage(self.pageImage.url).placeholder {
                // Placeholder while downloading.
                Image(systemName: "arrow.2.circlepath.circle")
                    .font(.largeTitle)
                    .opacity(0.3)
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            
            
            VStack {
                Spacer()
                Text(photoDescription())
                    .foregroundColor(.gray)
                    .padding(3)
                    .padding(.bottom, 50)
                    .background(Color.black)
                    .cornerRadius(5)
            }
        }
        //.background(Color.black)
        //.edgesIgnoringSafeArea(.all)
    }
    
    func photoDescription() -> String!{
        var result = ""
        
        if let description = pageImage.description{
            result += description
        }
        if let artist = pageImage.artist{
            result += (" ("+artist+")")
        }
        
        return result
    }
}
