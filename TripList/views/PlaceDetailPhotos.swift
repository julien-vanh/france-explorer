//
//  PlaceDetailPhotos.swift
//  TripList
//
//  Created by Julien Vanheule on 30/01/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import URLImage
import WaterfallGrid

struct PlaceDetailPhotos: View {
    var place: Place
    @State private var pageImages: [ImageMetadata] = []
    @State private var showModal: Bool = false
    @State var selectedPageImage: ImageMetadata?
    @ObservedObject var appState = AppState.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        WaterfallGrid(pageImages, id: \.self) { pageImage in
            Button(action: {
                self.selectedPageImage = pageImage
                self.showModal.toggle()
            }) {
                URLImage(pageImage.thumburl!, placeholder: { _ in
                    Image(systemName: "photo")
                        .foregroundColor(.clear)
                        .frame(height: 0)
                }, content: {
                    $0.image
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                    
                })
            }
        }.gridStyle(
            columnsInPortrait: UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3,
            columnsInLandscape: UIDevice.current.userInterfaceIdiom == .phone ? 3 : 4,
            animation: .none
        )
        .navigationBarTitle(Text(place.titleLocalized), displayMode: .inline)
        .sheet(isPresented: $showModal, content: {
            PlacePhotosModal(images: self.pageImages, initialeImage: self.selectedPageImage!)
        })
        .onAppear(perform: {
            
            if let wikiPageId = self.place.wikiPageId {
                WikipediaService.shared.getPageImages(wikiPageId) { result in
                    switch result {
                    case .failure(let error):
                        self.appState.displayError(error: error)
                    case .success(let value):
                        self.pageImages = value
                    }
                }
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
            
        })
    }
}

struct PlaceDetailPhotos_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailPhotos(place: PlaceStore.shared.get(id: "1"))
    }
}

struct PlacePhotosModal: View {
    var images: [ImageMetadata]
    var initialeImage: ImageMetadata
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            PhotoPager(photos: images, initiale: initialeImage)
            
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
                        self.dismiss()
                    }
                    Spacer()
                }
                Spacer()
            }
        }.background(Color.black).edgesIgnoringSafeArea(.bottom)
    }
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }

}

struct PhotoPager: View {
    var photosViews: [UIHostingController<PhotoFullscreen>]
    @State private var currentPageIndex: Int
    
    init(photos: [ImageMetadata], initiale: ImageMetadata){
        self.photosViews = photos.map { UIHostingController(rootView:PhotoFullscreen(pageImage: $0)) }
        _currentPageIndex = State(initialValue: photos.firstIndex(where: {$0.title == initiale.title}) ?? 0)
    }
    
    var body: some View {
        PageViewController(currentPageIndex: $currentPageIndex, viewControllers: photosViews)
            .edgesIgnoringSafeArea(.all)
    }
}

struct PhotoFullscreen: View {
    @State var scale: CGFloat = 1
    @State var lastScaleValue: CGFloat = 1.0
    
    var pageImage: ImageMetadata
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .center) {
                Color.black
                
                URLImage(self.pageImage.thumburl!, placeholder: { _ in
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width:geometry.size.width)
                }, content: { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)// Make image resizable
                        .frame(width:geometry.size.width, height: geometry.size.height)
                        .scaleEffect(self.scale)
                        .clipped()
                        .gesture(MagnificationGesture()
                            .onChanged { val in
                                let delta = val / self.lastScaleValue
                                self.lastScaleValue = val
                                self.scale = self.scale * delta
                            }.onEnded { val in
                                self.lastScaleValue = 1.0
                                self.scale = max(self.scale, 1.0)
                            }
                        )
 
                })
                
                
                VStack {
                    Spacer()
                    Text(self.photoDescription())
                        .lineLimit(4)
                        .foregroundColor(.white)
                        .padding(3)
                        .background(BlurView(style: .dark))
                        .cornerRadius(5)
                        .padding(.bottom, 50)
                }
            }
        }
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


