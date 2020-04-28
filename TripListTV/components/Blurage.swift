//
//  Blurage.swift
//  TripListTV
//
//  Created by Julien Vanheule on 28/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//
import UIKit

protocol Blurable {
    func addBlur(_ alpha: CGFloat, style: UIBlurEffect.Style)
}

extension Blurable where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.5, style: UIBlurEffect.Style = .dark) {
        // create effect
        let effect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: effect)

        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha

        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Blurable {}
