//
//  ProgressBar.swift
//  TripList
//
//  Created by Julien Vanheule on 12/03/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    var value: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .strokeBorder(Color(UIColor.explored), lineWidth: 2)
                Rectangle()
                    .strokeBorder(Color(UIColor.explored), lineWidth: 0)
                    .background(Color(UIColor.explored))
                    .frame(width:self.getProgressBarWidth(geometry: geometry))
                    
                    .animation(.default)
            }
            .frame(height:10)
        }
    }
    
    func getProgressBarWidth(geometry:GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .global)
        return frame.size.width * value
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: (0.6))
    }
}
