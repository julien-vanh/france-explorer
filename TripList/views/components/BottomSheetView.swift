//https://swiftwithmajid.com/2019/12/11/building-bottom-sheet-in-swiftui/

//
//  BottomSheetView.swift
//
//  Created by Majid Jabrayilov
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 15
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
}

enum BottomSheetState {
    case full
    case middle
    case closed
}

struct BottomSheetView<Content: View>: View {
    @Binding var state: BottomSheetState

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        switch state {
            case .full: return 0
            case .middle: return maxHeight/2
            case .closed: return maxHeight
        }
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
            self.state = .full
        }
    }

    init(state: Binding<BottomSheetState>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = 0
        self.maxHeight = maxHeight
        self.content = content()
        self._state = state
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding(4)
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(BlurView(style: .systemThinMaterial))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, aState, _ in
                    aState = value.translation.height
                }.onEnded { value in
                    
                    //Determine le state en fin de scroll
                    if value.predictedEndTranslation.height < 0 {
                        self.state = .full
                    } else if value.predictedEndLocation.y > self.maxHeight {
                        self.state = .closed
                    } else {
                        self.state = .middle
                    }
                }
            )
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(state: .constant(.middle), maxHeight: 600) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
