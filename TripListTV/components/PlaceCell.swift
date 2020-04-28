//
//  ThumbnailPageCell.swift
//  PrettyWiki
//
//  Created by Julien Vanheule on 24/10/2019.
//  Copyright © 2019 Julien Vanheule. All rights reserved.
//

import Foundation
import UIKit

class PlaceCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var unfocusedConstraint: NSLayoutConstraint!
    
    private var focusedConstraint: NSLayoutConstraint!
    
    private var place: Place!
    
    func configure(place: Place) {
        self.place = place
        titleLabel.text = place.titleLocalized
        self.imageView.image  = ImageStore.shared.uiimage(forPlace: place)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusedConstraint = titleLabel.topAnchor.constraint(equalTo: imageView.focusedFrameGuide.bottomAnchor, constant: 6)
        imageView.adjustsImageWhenAncestorFocused = true
        titleLabel.layer.zPosition = 99
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        focusedConstraint.isActive = isFocused
        unfocusedConstraint.isActive = !isFocused
        
        if place != nil {
            titleLabel.textColor = isFocused ? UIColor.explored : .white
        }
        
    }
        
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        setNeedsUpdateConstraints()
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
