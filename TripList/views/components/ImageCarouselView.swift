//
//  ImageCarouselView.swift
//  https://levelup.gitconnected.com/swiftui-create-an-image-carousel-using-a-timer-ed546aacb389
//

import SwiftUI
import Combine

// 2
struct ImageCarouselView<Content: View>: View {
    // 3
    private var numberOfImages: Int
    private var content: Content

    @State private var currentIndex: Int = 0
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    // 6
    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .bottom) {
               HStack(spacing: 0) {
                   self.content
               }
               .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading) // 4
               .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0) // 5
               .animation(.spring()) // 6
               .onReceive(self.timer) { _ in
                   
                   self.currentIndex = (self.currentIndex + 1) % 3
               }
               
               HStack(spacing: 3) {
                   ForEach(0..<self.numberOfImages, id: \.self) { index in
                       Circle()
                           .frame(width: 8, height: 8)
                           .foregroundColor(index == self.currentIndex ? Color.gray : .white)
                           .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                           .padding(.bottom, 8)
                           .animation(.spring())
                   }
               }
            }
            
            
        }
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        
        // 8
        GeometryReader { geometry in
            ImageCarouselView(numberOfImages: 3) {
                Image("image_carousel_1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                Image("image_carousel_2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                Image("image_carousel_3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }.frame(width: UIScreen.main.bounds.width, height: 200, alignment: .center)
    }
}
